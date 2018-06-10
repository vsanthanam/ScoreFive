//
//  NewGameController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 6/9/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "NewGameController.h"

@interface NewGameController ()

@end

@implementation NewGameController

+ (instancetype)newGameController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewGame" bundle:[NSBundle mainBundle]];
    
    return [storyboard instantiateViewControllerWithIdentifier:@"NewGameControllerID"];
    
}

@end
