//
//  YHLagMonitor.m
//  YHLagMonitor_Example
//
//  Created by Vanha on 2019/12/18.
//  Copyright © 2020 wanwan. All rights reserved.
//
#define STUCKMONITORRATE 88

#import "YHLagMonitor.h"
#import "YHLagCallStack.h"

@interface YHLagMonitor ()

@end

@implementation YHLagMonitor {
    int _timeoutCount;
    CFRunLoopObserverRef _runLoopObserver;
    dispatch_semaphore_t _semaphore;
    CFRunLoopActivity _runLoopActivity;
    
}

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (void)beginMonitor {
    self.isMonitoring = YES;

    if (_runLoopObserver) {
        return;
    }
    
    _semaphore = dispatch_semaphore_create(0);
  
    CFRunLoopObserverContext content = {0,(__bridge void*)self,NULL,NULL};
    _runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runloopObserverCallBack, &content);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self->_semaphore, dispatch_time(DISPATCH_TIME_NOW, STUCKMONITORRATE * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->_runLoopObserver) {
                    self->_timeoutCount = 0;
                    self->_semaphore = 0;
                    self->_runLoopActivity = 0;
                    return;
                }
                
                if (self->_runLoopActivity == kCFRunLoopBeforeSources || self->_runLoopActivity == kCFRunLoopAfterWaiting) {
                    if (++self->_timeoutCount < 3) {
                        continue;
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        NSString *stackStr = [YHLagCallStack callStackWithType:SMCallStackTypeMain];
                        
                        NSLog(@"卡顿：%@",stackStr);
                    });
                }
            }
            self->_timeoutCount = 0;
        }
    });
}

- (void)stopMonitor {
    self.isMonitoring = NO;
    if (!_runLoopObserver) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}


static void runloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    YHLagMonitor *lagMonitor = (__bridge YHLagMonitor*)info;
    lagMonitor ->_runLoopActivity = activity;
    dispatch_semaphore_t semaphore = lagMonitor->_semaphore;
    dispatch_semaphore_signal(semaphore);
    
}

@end
