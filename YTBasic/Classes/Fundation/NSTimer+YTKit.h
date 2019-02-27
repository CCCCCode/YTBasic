//
//  NSTimer+YTKit.h
//  CRFMarket
//
//  Created by HellowWorld on 2018/9/12.
//  Copyright © 2018年 CCCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YTKit)

-(void)pause;
-(void)resume;
-(void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
