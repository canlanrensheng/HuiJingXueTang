//
//  NSString+URLEncoding.m
//  BoceshQuote
//
//  Created by jagtu on 14-1-9.
//  Copyright (c) 2014年 66money. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
//NSString 编码
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self, NULL,CFSTR("!*'()^;:@&=+$,/?%#[]"),kCFStringEncodingUTF8));

    return result;
}
//NSString 解码
- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self, CFSTR(""),  kCFStringEncodingUTF8));

    return result;
}
//NSString MD5加密
-(NSString *)MD5String
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
    
}

@end
