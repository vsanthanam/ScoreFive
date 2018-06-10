//
//  AppDelegate.m
//  ScoreFive
//
//  Created by Varun Santhanam on 6/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation AppDelegate

@synthesize persistentContainer = _persistentContainer;
@synthesize managedObjectModel = _managedObjectModel;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Property Access Methods

- (NSPersistentContainer *)persistentContainer {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!self->_persistentContainer) {
            
            self->_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ScoreFive" managedObjectModel:self.managedObjectModel];
            
            [self->_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
               
                if (error) {
                    
                    // handle and abort
                    abort();
                    
                }
                
            }];
            
        }
        
    });
    
    return _persistentContainer;
    
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (!_managedObjectModel) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ScoreFive" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
    }
    
    return _managedObjectModel;
    
}

#pragma mark - Public Instance Methods

- (void)saveContext {
    
    NSError *error;
    [self saveContextWithError:&error];
    
    if (error) {
        
        // handle and abort
        abort();
        
    }
    
}

- (void)saveContextWithError:(NSError *__autoreleasing *)error {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *errorObj;
    
    if (context.hasChanges && ![context save:&errorObj]) {
        
        *error = errorObj;
        
    }
    
}

@end
