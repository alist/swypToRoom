//
//  NSDate+Relative.h
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/5/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Relative)

-(NSString *)distanceOfTimeInWordsSinceDate:(NSDate *)aDate;
-(NSString *)distanceOfTimeInWordsToNow;

@end
