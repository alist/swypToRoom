//
//  FileObject.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "FileObject.h"
#import "FileCell.h"
#import <Parse/Parse.h>

@implementation FileObject

@synthesize fileName, uploadTime, fbName, fbID;

-(id)initWithParseObject:(PFObject *)parseObject {
    if (self = [super init]){
        self.fileName = ((PFFile *)[parseObject objectForKey:@"file"]).name;
        self.uploadTime = [parseObject updatedAt];
        self.fbName = ((PFUser *)[parseObject objectForKey:@"user"]).username;
        self.fbID = ((PFUser *)[parseObject objectForKey:@"user"]).facebookId;
    }
    
    return self;
}

-(UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleSubtitle;
}

-(Class)cellClass {
    return [FileCell class];
}

@end
