//
//  AppDelegate.h
//  YHLagMonitor_Example
//
//  Created by Vanha on 2019/12/18.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

