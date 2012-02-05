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

-(id)initWithParseObject:(PFObject *)pObject {
    if (self = [super init]){
        self.fileName = ((PFFile *)[pObject objectForKey:@"file"]).name;
        self.uploadTime = [pObject updatedAt];
        self.fbName = ((PFUser *)[pObject objectForKey:@"user"]).username;
        self.fbID = [pObject objectForKey:@"userFBId"];
				
		PFFile * thumbnail		=	[pObject objectForKey:@"thumbnail"];
		NSString * urlForThumb	=	[thumbnail url];
		self.thumbnailURL		=	urlForThumb;

		PFFile * file			=	[pObject objectForKey:@"file"];
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
