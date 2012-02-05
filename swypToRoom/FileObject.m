//
//  FileObject.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "FileObject.h"
#import "FileCell.h"

@implementation FileObject

@synthesize fileName, uploadTime, fbName, fbID, thumbnailURL, fileURL;

-(id)initWithParseObject:(PFObject *)parseObject {
    if (self = [super init]){
        self.fileName = ((PFFile *)[parseObject objectForKey:@"file"]).name;
        self.uploadTime = [parseObject updatedAt];
        self.fbName = ((PFUser *)[parseObject objectForKey:@"user"]).username;
        self.fbID = [parseObject objectForKey:@"userFBId"];

		PFFile * thumbnail		=	[parseObject objectForKey:@"thumbnail"];
		NSString * urlForThumb	=	[thumbnail url];
		self.thumbnailURL		=	urlForThumb;

		PFFile * file			=	[parseObject objectForKey:@"file"];
		NSString * urlForfile	=	[file url];
		self.fileURL			=	urlForfile;
		self.fileName			=	file.name;
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
