
//
//  YTBasic.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/23.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#ifndef YTBasic_h
#define YTBasic_h

#if __has_include(<CRFFramework/YTBasic.h>)

#import <CRFFramework/YTGlobal.h>
#import <CRFFramework/YTHelper.h>

#import <CRFFramework/UIFont+YTKit.h>
#import <CRFFramework/UIColor+YTKit.h>
#import <CRFFramework/UIImage+YTKit.h>
#import <CRFFramework/UIDevice+YTKit.h>
#import <CRFFramework/UIView+YTKit.h>

#import <CRFFramework/NSData+YTKit.h>
#import <CRFFramework/NSString+YTKit.h>
#import <CRFFramework/NSFileManager+YTKit.h>
#import <CRFFramework/NSObject+YTKit.h>
#import <CRFFramework/NSDate+YTKit.h>
#import <CRFFramework/NSTimer+YTKit.h>

#import <CRFFramework/MBProgressHUD+YTKit.h>


#else

#import "YTGlobal.h"
#import "YTHelper.h"

#import "UIFont+YTKit.h"
#import "UIColor+YTKit.h"
#import "UIImage+YTKit.h"
#import "UIDevice+YTKit.h"
#import "UIView+YTKit.h"

#import "NSData+YTKit.h"
#import "NSString+YTKit.h"
#import "NSFileManager+YTKit.h"
#import "NSObject+YTKit.h"
#import "NSDate+YTKit.h"
#import "NSTimer+YTKit.h"

#import "MBProgressHUD+YTKit.h"

#endif

#define YTColorHex(hex) [UIColor colorWithHexString:hex]
#define YTFont(fontsize) [UIFont scaleSystemFontOfSize:fontsize]


#endif /* YTBasic_h */
