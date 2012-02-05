//
//  NSDate+Relative.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/5/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "NSDate+Relative.h"

@implementation NSDate (Relative)

-(NSString *)distanceOfTimeInWordsToNow {
    return [self distanceOfTimeInWordsSinceDate:[NSDate date]];
    
}

-(NSString *)distanceOfTimeInWordsSinceDate:(NSDate *)aDate {
    double interval = [self timeIntervalSinceDate:aDate];
    
    NSString *timeUnit;
    int timeValue;
    
    if (interval < 0) {
        interval = interval * -1;        
    }
    
    if (interval< 60) {
        return @"seconds";
        
    } else if (interval< 3600) { // minutes
        
        timeValue = round(interval / 60);
        
        if (timeValue == 1) {
            timeUnit = @"minute";
            
        } else {
            timeUnit = @"minutes";
            
        }
        
        
    } else if (interval< 86400) {
        timeValue = round(interval / 60 / 60);
        
        if (timeValue == 1) {
            timeUnit = @"hour";
            
        } else {
            timeUnit = @"hours";
        }
        
        
    } else if (interval< 2629743) {
        int days = round(interval / 60 / 60 / 24);
        
        if (days < 7) {
            
            timeValue = days;
            
            if (timeValue == 1) {
                timeUnit = @"day";
            } else {
                timeUnit = @"days";
            }
            
        } else if (days < 30) {
            int weeks = days / 7;
            
            timeValue = weeks;
            
            if (timeValue == 1) {
                timeUnit = @"week";
            } else {
                timeUnit = @"weeks";
            }
            
            
        } else if (days < 365) {
            
            int months = days / 30;
            timeValue = months;
            
            if (timeValue == 1) {
                timeUnit = @"month";
            } else {
                timeUnit = @"months";
            }
            
        } else if (days < 30000) { // this is roughly 82 years. After that, we'll say 'forever'
            int years = days / 365;
            timeValue = years;
            
            if (timeValue == 1) {
                timeUnit = @"year";
            } else {
                timeUnit = @"years";
            }
            
        } else {
            return @"forever ago";
        }
    }
    
    return [NSString stringWithFormat:@"%d %@", timeValue, timeUnit];
    
}

@end
