//
//  NSDate+JHExtension.h
//
//  Created by 赖锦浩 on 16/5/18.
//  Copyright © 2016年 赖锦浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JHExtension)
- (NSDateComponents *)intervalToDate:(NSDate *)date;

- (NSDateComponents *)intervalToNow;

/** 今年 */
- (BOOL)isThisYear;

/** 今天 */
- (BOOL)isToDay;

/** 昨天 */
- (BOOL)isYesterday;

/** 明天 */
- (BOOL)isTomorrow;

@end
