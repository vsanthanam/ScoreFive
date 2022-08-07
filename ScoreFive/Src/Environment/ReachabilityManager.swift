// ScoreFive
// ReachabilityManager.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import Network
import NetworkReachability

final class ReachabilityManager: ObservableObject {

    // MARK: - API

    enum Status {
        case ethernet
        case wifi
        case cellular
        case unknown
        case disconnected
    }

    static let shared: ReachabilityManager = .init()

    @Published
    var reachability: Status = .disconnected

    // MARK: - Private

    private init() {
        setUp()
    }

    var task: Task<Void, Never>?

    private func setUp() {
        task = Task {
            for await networkPath in NetworkMonitor.networkPathUpdates {
                if networkPath.usesInterfaceType(.wiredEthernet) {
                    self.reachability = .ethernet
                } else if networkPath.usesInterfaceType(.wifi) {
                    self.reachability = .wifi
                } else if networkPath.usesInterfaceType(.cellular) {
                    self.reachability = .cellular
                } else if networkPath.status == .satisfied {
                    self.reachability = .unknown
                } else {
                    self.reachability = .disconnected
                }
            }
        }
    }

    deinit {
        task?.cancel()
    }
}
