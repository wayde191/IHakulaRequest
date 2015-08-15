//
//  IHArithmeticKit.h
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHArithmeticKit : NSObject

+ (NSString *)getStrByBytesIndex:(NSUInteger)bytesIndex fromString:(NSString *)sourceStr;
+ (NSUInteger)lengthOfComplexStr: (NSString *)complexStr;

// Data Parse
+ (NSDictionary *)parseJsonDataToDictionary:(NSData *)jsonData;
+ (NSDictionary *)parseJsonStringToDictionary:(NSString *)jsonSourceStr;
+ (NSString *)getStringFromDictionary:(NSDictionary *)dic;

// Date Format
+ (NSString *)getTimeWithMonthAndHourFromServerTimeStr:(NSString *)serverTimeStr;
+ (NSString *)getTimeSince1970:(NSString *)timeStr;
+ (NSArray *)getYearMonthDayOfToday;
+ (NSString *)getCurrentTimetamp;

+ (NSDate *)get12MonthsLater;
+ (NSDate *)getDateFromString:(NSString *)dateString;
+ (NSString *)getStringFromDate:(NSDate *)theDate;

// NSString
+ (NSString *)getStringValue:(id)value;
+ (NSString *)trim:(NSString *)stringValue;


@end
