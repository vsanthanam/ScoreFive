//
//  NewGameViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 6/9/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "NewGameViewController.h"

@interface NewGameViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewGameViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
    
}

@end
