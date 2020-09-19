//
//  YHLagMonitor.h
//  YHLagMonitor_Example
//
//  Created by Vanha on 2019/12/18.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHLagMonitor : NSObject

+ (instancetype)shareInstance;

@property(nonatomic) BOOL isMonitoring;

- (void)beginMonitor;

- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
