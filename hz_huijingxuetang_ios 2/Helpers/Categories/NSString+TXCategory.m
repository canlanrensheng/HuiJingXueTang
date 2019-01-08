//
//  NSString+Category.m
//  BM
//
//  Created by txooo on 17/4/17.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "NSString+TXCategory.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (TXCategory)

-(BOOL)isEmpty {
    if ([self isEqual:[NSNull null]]) {
        return YES;
    } else if ([self isKindOfClass:[NSNull class]]){
        return YES;
    } else if (self == nil){
        return YES;
    } else if ([@"" isEqualToString:self]){
        return YES;
    }
    return NO;
}

- (BOOL)validateMobile {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    //测试号段 1224444
    if (self.length == 11 && [[self substringToIndex:7] isEqualToString:@"1224444"]) {
        return YES;
    }
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @return 返回值类型为BOOL
 */
- (BOOL)validateUrl {
    NSError *error;
    // 正则1 必须带http
    //    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    NSString *regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        if ([self substringWithRange:match.range]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)containChinese {
    for(int i=0; i< [self length]; i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)pinyin {
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial {
    if (self.length == 0) {
        return nil;
    }
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    
    return initial;
}

- (NSString *)dateConvertToYYMMDDHHMM {
    if ([self isEmpty]) {
        return @"";
    }
    NSString *date = [self stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return [date substringToIndex:16];
}

- (NSString *)dateConvertToYYMMDDHHMMSS {
    if ([self isEmpty]) {
        return @"";
    }
    NSString *dateStr = [[[self stringByReplacingOccurrencesOfString:@"T" withString:@" "] componentsSeparatedByString:@"."] firstObject];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@:%@",[dateArr firstObject],dateArr[1]];
}

- (NSString *)dateConvertToYYMMDDHHMMSSLastTime {
    if ([self isEmpty]) {
        return @"";
    }
    NSString *dateStr = [[self componentsSeparatedByString:@"T"] lastObject];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@:%@",[dateArr firstObject],dateArr[1]];
}

- (NSString *)dateWithoutTConvertToYYMMDDHHMMSS {
    if ([self isEmpty]) {
        return @"";
    }
    NSArray *array = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/ "]];
    if (array.count >=3) {
        return [NSString stringWithFormat:@"%@-%@-%@ %@",array[2],array.firstObject,array[1],array.lastObject];
    }
    return self;
}

- (NSString *)dateConvertToYYMMDD {
    if ([self isEmpty]) {
        return @"";
    }
    return [self substringToIndex:10];
}

- (NSString *)dateConvertToHHMMSS {
    if (self.isEmpty) {
        return @"";
    }
    return [[self componentsSeparatedByString:@"T"].lastObject componentsSeparatedByString:@"."].firstObject;
}

- (NSString *)dateConvertToHHMM {
    if (self.isEmpty) {
        return @"";
    }
    return [[[self componentsSeparatedByString:@"T"].lastObject componentsSeparatedByString:@"."].firstObject substringToIndex:5];
}

- (NSString *)dateConvertToMMDD {
    if (self.isEmpty) {
        return @"";
    }
    return [[self componentsSeparatedByString:@"T"].firstObject substringFromIndex:5];
}

- (NSString *)dateConvertToYYMMDDWithPoint {
    if ([self isEmpty]) {
        return @"";
    }
    return [[self substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

- (NSString *)dateOfWeekDay {
    if ([self isEmpty]) {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatterDate=[myDateFormatter dateFromString:self];
    
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    return [weekArray objectAtIndex:0];
}


//转json字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}




+(NSString *)dealNullStringWithObject:(id)object{
    NSString * string = nil;
    if(object == nil){
        return @"";
    }
    NSString *objectString = (NSString *)object;
    if ([objectString isEqual:@"NULL"] || [objectString isKindOfClass:[NSNull class]] || [objectString isEqual:[NSNull null]] || [objectString isEqual:NULL] || [[objectString class] isSubclassOfClass:[NSNull class]]  || [objectString isKindOfClass:[NSNull class]] || [[objectString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 || [objectString isEqualToString:@"<null>"] || [objectString isEqualToString:@"(null)"] || ([objectString isEqualToString:@"<null>"])){
        return @"";
    }else{
        string = objectString;
    }
    return string;
}

- (NSString *)md5String {
    const char * Cstr = [self UTF8String];
    unsigned char buff[16];
    CC_MD5(Cstr, (CC_LONG)strlen(Cstr), buff);
    NSMutableString *strrr = [NSMutableString string];
    for (int i = 0; i < 16; i ++) {
        [strrr appendFormat:@"%02x",buff[i]];
    }
    return strrr;
}

+ (NSString *)uuid {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    return (__bridge NSString *)uuidStr;
}

- (CGSize)sizeForFont:(UIFont *)font {
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSDictionary* attribs = @{NSFontAttributeName:font};
        return ([self sizeWithAttributes:attribs]);
    }
    //    return ([self sizeWithFont:font]);
    return CGSizeZero;
}

- (CGSize)sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSDictionary *attributes = @{NSFontAttributeName:font};
        CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
     CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size;
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

- (CGFloat)calculateWidthWithSize:(CGSize)size font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (void)setLineSpacingWithLabel:(UILabel *)label space:(CGFloat)space{
    NSMutableAttributedString * attributedString =  [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    [label setAttributedText:attributedString];
    [label sizeToFit];
}

//验证车牌号
- (BOOL)validateCarNo{
    NSString *carRegex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:self];
}

//处理空字符串
- (NSString *)validateString{
    if(self.length > 0){
        return self;
    }
    return  @"";
}


- (CGSize)calculateSize:(CGSize)size lineSpace:(CGFloat)lineSpace font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

- (CGSize)calculateAttributes:(NSDictionary *)attributes size:(CGSize)size{
    CGSize expectedLabelSize = CGSizeZero;
    expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

-(NSAttributedString *)attributeWithStr:(NSString *)str color:(UIColor *)color font:(UIFont *)font{
    NSRange range = [self rangeOfString:str];
    NSMutableAttributedString * newStr = [[NSMutableAttributedString alloc] initWithString:self];
    [newStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [newStr addAttribute:NSFontAttributeName value:font range:range];
    return  newStr;
}

- (NSAttributedString *)attributeWithStr:(NSString *)str color:(UIColor *)color font:(UIFont *)font withLastStringColor:(UIColor *)otherColor font:(UIFont *)otherFont {
    NSRange range = [self rangeOfString:str];
    NSRange range2 = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
    
    NSMutableAttributedString * newStr = [[NSMutableAttributedString alloc] initWithString:self];
    [newStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [newStr addAttribute:NSFontAttributeName value:font range:range];
    [newStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range2];
    [newStr addAttribute:NSFontAttributeName value:otherFont range:range2];
    return  newStr;
}

//富文本
-(NSAttributedString *)fuWenBenWithStr:(NSString * )str withColor:(UIColor *)color withFont:(UIFont *)font
{
    NSRange range = [self rangeOfString:str];
    NSMutableAttributedString * newStr = [[NSMutableAttributedString alloc] initWithString:self];
    [newStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [newStr addAttribute:NSFontAttributeName value:font range:range];
    //[newStr addAttribute: NSLinkAttributeName value: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:index]]] range:range];
    return  newStr;
}

-(NSAttributedString *)fuWenBenWithStr:(NSString * )str withColor:(UIColor *)color withFont:(UIFont *)font space:(CGFloat)space
{
    NSRange range = [self rangeOfString:str];
    NSMutableAttributedString * newStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [newStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    [newStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [newStr addAttribute:NSFontAttributeName value:font range:range];
    //[newStr addAttribute: NSLinkAttributeName value: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:index]]] range:range];
    return  newStr;
    
}

- (NSString *)encodePercentEscapeString{
    NSString *outputStr =
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */
                                                                 (__bridge CFStringRef)self,
                                                                 NULL, /* charactersToLeaveUnescaped */
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                 kCFStringEncodingUTF8);
    return outputStr;
}

- (NSString *)decodePercentEscapeString {
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,[outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

- (NSString *)conversionFormat{
    float floatValueNum = [self floatValue];
    int intValueNum = (int)floatValueNum;
    NSString * valueNumStr = nil;
    if(floatValueNum == intValueNum){
        valueNumStr =[NSString stringWithFormat:@"%d",intValueNum];
    }else{
        valueNumStr =[NSString stringWithFormat:@"%.2f",floatValueNum];
    }
    return valueNumStr;
}

- (NSString *)imageUrlWithImageSize:(ImageSizeType)ImageSizeType {
    switch (ImageSizeType) {
        case ImageSizeTypeDefault:
            return [self stringByAppendingString:@",1,250,250,3"];
            break;
        case (ImageSizeTypeThumbnail):
            return [self stringByAppendingString:@",1,80,80,3"];
            break;
        case (ImageSizeTypeFullScreen):
            return [self stringByAppendingString:@",1,480,480,3"];
            break;
        case (ImageSizeTypeOriginal):
            return self;
            break;
    }
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (NSString *)dealNullDataWithReplaceString:(NSString *)replaceString{
    if([NSString dealNullStringWithObject:self].length > 0){
        return self;
    }
    return replaceString;
}

//处理日期单个的数据
+ (NSString *)convertDateSingleData:(NSInteger)date {
    if([NSString stringWithFormat:@"%ld",date].length < 2) {
        return [NSString stringWithFormat:@"0%ld",date];
    }
    return [NSString stringWithFormat:@"%ld",date];
}

@end
