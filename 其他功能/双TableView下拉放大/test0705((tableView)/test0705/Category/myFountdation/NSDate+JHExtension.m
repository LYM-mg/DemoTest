//
//  NSDate+JHExtension.m

//  Created by 赖锦浩 on 16/5/18.
//  Copyright © 2016年 赖锦浩. All rights reserved.
/*
 //日期格式
 //    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
 //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
 //
 //    //日历
 //    NSCalendar *calendar = [NSCalendar currentCalendar];
 //
 //    //当前的时间
 //    NSDate *date = [NSDate date];
 //
 //    NSDate *createdDate = [fmt dateFromString:topic.created_at];
 //
 //    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
 //
 //    NSDateComponents *cmp = [calendar components:unit fromDate:date toDate:createdDate options:NSCalendarWrapComponents];
 //
 //    NSLog(@"%@",cmp);
 
 


*/

#import "NSDate+JHExtension.h"

@implementation NSDate (JHExtension)
- (NSDateComponents *)intervalToDate:(NSDate *)date
{
    //创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //元素有哪些
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self toDate:date options:0];
}

- (NSDateComponents *)intervalToNow
{
    return [self intervalToDate:[NSDate date]];
}

/** 今年 */
- (BOOL)isThisYear
{
    //创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //比较
    NSInteger nowDate = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfDate = [calendar component:NSCalendarUnitYear fromDate:self];

    return nowDate == selfDate;
    
}

/** 今天 */
- (BOOL)isToDay
{
    //创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //比较
    NSDateComponents *nowCmp = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmp = [calendar components:unit fromDate:self];
    
    return
    nowCmp.year == selfCmp.year &&
    nowCmp.month == selfCmp.month &&
    nowCmp.day == selfCmp.day;

}

/** 昨天 */
- (BOOL)isYesterday
{
    //日期的格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //因为只需要比较 年月日 不需要比较具体的时间,所以把格式转换成 xxxx年xx月xx日就可以
    //先将当前的时间转换成当前格式的字符串
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    //再将当前字符串的格式转换成时间
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    //先将当前的时间转换成当前格式的字符串
    NSString *selfStr = [fmt stringFromDate:self];
    //再将当前字符串的格式转换成时间
    NSDate *selfDate = [fmt dateFromString:selfStr];
    
    
    //创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //比较
    NSDateComponents *cmps = [calendar components:unit fromDate:nowDate toDate:selfDate options:0];
    
    return
    cmps.year == 0 &&
    cmps.month == 0 &&
    cmps.day == -1;
}

/** 明天 */
- (BOOL)isTomorrow
{

    //日期的格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //因为只需要比较 年月日 不需要比较具体的时间,所以把格式转换成 xxxx年xx月xx日就可以
    //先将当前的时间转换成当前格式的字符串
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    //再将当前字符串的格式转换成时间
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    //先将当前的时间转换成当前格式的字符串
    NSString *selfStr = [fmt stringFromDate:self];
    //再将当前字符串的格式转换成时间
    NSDate *selfDate = [fmt dateFromString:selfStr];
    
    
    //创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //比较
    NSDateComponents *cmps = [calendar components:unit fromDate:nowDate toDate:selfDate options:0];
    
    return
    cmps.year == 0 &&
    cmps.month == 0 &&
    cmps.day == 1;
    

}
@end
