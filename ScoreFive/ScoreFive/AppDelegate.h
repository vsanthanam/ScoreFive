//
//  AppDelegate.h
//  ScoreFive
//
//  Created by Varun Santhanam on 6/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

