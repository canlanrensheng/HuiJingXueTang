//
//  NSString+URLEncoding.h
//  BoceshQuote
//
//  Created by 胡明星 on 14-1-9.
//  Copyright (c) 2014年 66money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
CFStringRef CFURLCreateStringByReplacingPercentEscapes (
                                                        CFAllocatorRef allocator,
                                                        CFStringRef    originalString,
                                                        CFStringRef    charactersToLeaveEscaped
                                                        );

- (NSString*)URLDecodedString;
- (NSString *)URLEncodedString;
- (NSString *)MD5String;



@end
