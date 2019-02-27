//
//  NSTimer+YTKit.m
//  CRFMarket
//
//  Created by HellowWorld on 2018/9/12.
//  Copyright © 2018年 CCCode. All rights reserved.
//

#import "NSTimer+YTKit.h"

@implementation NSTimer (YTKit)

- (void)pause{
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}


@end
