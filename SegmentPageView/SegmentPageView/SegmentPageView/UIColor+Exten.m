//
//  UIColor+Exten.m
//  SegmentPageView
//
//  Created by MenThu on 2018/4/16.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "UIColor+Exten.h"

@implementation UIColor (Exten)

+ (UIColor *)colorWithHexString:(NSString *)hexColorString alpha:(CGFloat)alpha{
    unsigned colorValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexColorString];
    if ([hexColorString rangeOfString:@"#"].location != NSNotFound) {
        [scanner setScanLocation:1];
    }
    [scanner scanHexInt:&colorValue];
    return [UIColor colorWithRed:((colorValue & 0xFF0000) >> 16) / 255.0 green:((colorValue & 0xFF00) >> 8) / 255.0 blue:((colorValue & 0xFF) >> 0) / 255.0 alpha:alpha];
}

@end
