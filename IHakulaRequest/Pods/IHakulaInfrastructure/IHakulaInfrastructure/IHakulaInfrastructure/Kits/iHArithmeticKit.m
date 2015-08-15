//
//  IHArithmeticKit.m
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHArithmeticKit.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@implementation iHArithmeticKit

#pragma mark - String
+ (NSString *)getStrByBytesIndex:(NSUInteger)bytesIndex fromString:(NSString *)sourceStr
{
    NSData *dataFromSourceStr = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    if ([dataFromSourceStr length] <= bytesIndex) {
        return sourceStr;
    }
    
    NSRange range = NSMakeRange(0, bytesIndex);
    
    UInt8 bytes[range.length];
    [dataFromSourceStr getBytes:bytes range:range];
    
    NSString *newStr;
    for (int i = 0; i < 3; i++) {
        NSData *newData = [[NSData alloc] initWithBytes:bytes length:(sizeof(bytes) - i)];
        newStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        if (newStr) {
            break;
        }
    }
    
    return newStr;
    
}

+ (NSUInteger)lengthOfComplexStr:(NSString *)complexStr
{
    NSData *dataFromComplexStr = [complexStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return [dataFromComplexStr length];
}

#pragma mark - Data
+ (NSDictionary *)parseJsonDataToDictionary:(NSData *)jsonData
{
    NSError *e = nil;
    NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:
                                 [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&e]];
    
    return responseDic;
}

+ (NSDictionary *)parseJsonStringToDictionary:(NSString *)jsonSourceStr
{
    NSData *jsonData = [jsonSourceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:
                                        [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&e]];
    
    return responseDic;
}

+ (NSString *)getStringFromDictionary:(NSDictionary *)dic {
    NSString *theString = [[CJSONSerializer serializer] serializeDictionary:dic];
//    return [NSString encodeURL: theString];
    return theString;
}

#pragma mark - Date
+ (NSString *)getTimeWithMonthAndHourFromServerTimeStr:(NSString *)serverTimeStr
{
    // serverTimeStr : Wed Jun 01 00:50:25 +0800 2011
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    NSDate *date = [dateFormat dateFromString:serverTimeStr];
    
    [dateFormat setDateFormat:@"MM'月'dd'日' HH:mm"];
    NSString *formattedTimeStr = [dateFormat stringFromDate:date];
    
    return formattedTimeStr;
}

+ (NSString *)getTimeSince1970:(NSString *)timeStr
{
    NSTimeInterval timeInterval = [timeStr intValue]; 
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy'/'MM'/'dd"];
//    [dateFormatte setDateFormat:@"MM'/'dd'/'yyyy HH:mm"];
    // Analyze
    NSString *readableTimeStr = [NSString stringWithString: [dateFormatte stringFromDate:date]];
    return readableTimeStr;
}

+ (NSDate *)get12MonthsLater {
    return [[NSDate alloc] initWithTimeInterval:365*24*60*60 sinceDate:[NSDate date]];
}

+ (NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [formatter dateFromString:dateString];
}

+ (NSString *)getStringFromDate:(NSDate *)theDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:theDate];
}

+ (NSArray *)getYearMonthDayOfToday {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy M d"];
    // Analyze
    NSString *readableTimeStr = [NSString stringWithString: [dateFormatte stringFromDate:date]];
    
    
    return [readableTimeStr componentsSeparatedByString:@" "];
}

+ (BOOL)isEarlierThanTime:(NSString *)timeStr minutes:(int)mins {
    NSInteger oldTimeInteverl = [timeStr integerValue];
    NSInteger nowTimeInteverl = [[NSDate date] timeIntervalSince1970];
    
    if ((nowTimeInteverl - oldTimeInteverl) >= mins * 60) {
        return YES;
    }
    return NO;
}

+ (NSString *)getCurrentTimetamp {
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatte setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    
    return [dateFormatte stringFromDate:[NSDate date]];
}

#pragma mark - NSStringValue
+ (NSString *)getStringValue:(id)value {
    NSString *strValue = @"";
    if ([value isKindOfClass:[NSNumber class]]) {
        strValue = [value stringValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        strValue = value;
    }
    
    return strValue;
}

+ (NSString *)trim:(NSString *)stringValue {
    return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
