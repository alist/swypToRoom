//
//  SavedRoomObject.m
//  swypToRoom
//
//  Created by Alexander List on 2/5/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SRSavedRoomFile.h"
#import "FileCell.h"

@implementation SRSavedRoomFile

@dynamic fileName;
@dynamic fileType;
@dynamic dateAdded;
@dynamic thumbnailJPGData;
@dynamic fileData;
@dynamic fileCreatorFBId;

-(void)awakeFromInsert{
	[super awakeFromInsert];

	[self setDateAdded:[NSDate date]];
}

-(void) prefillFromFileObject:(FileObject*)object{
	if (object == nil){
		return;
	}
	[self setFileName:[object fileName]];
	NSArray * components =	[[object fileName] componentsSeparatedByString:@"."];

	NSString * fileName	=	nil;
	if ([components count] == 2){
		fileName	=	[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
	} 
	
	[self setFileType:fileName];
	
	if (StringHasText([object fileURL]) && StringHasText([object thumbnailURL])){
		[NSThread detachNewThreadSelector:@selector(_fetchDataFromURLSInDictionary:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:[object thumbnailURL],@"thumb",[object fileURL],@"file", nil]];
	}
}

-(void) _fetchDataFromURLSInDictionary:(NSDictionary*)urlDict{
	@autoreleasepool {
		NSString * thumbURL = [urlDict objectForKey:@"thumb"];		
		
		if (StringHasText(thumbURL)){
			NSData * downloadedThumbData	=	[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]];
			[self performSelectorOnMainThread:@selector(setThumbnailJPGData:) withObject:downloadedThumbData waitUntilDone:TRUE];
		}

		NSString * fileURL	= [urlDict objectForKey:@"file"];
		if (StringHasText(fileURL)) {
			NSData * downloadedFileData		=	[NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
			[self performSelectorOnMainThread:@selector(setFileData:) withObject:downloadedFileData waitUntilDone:TRUE];
		}
	}
}

-(UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleSubtitle;
}

-(Class)cellClass {
    return [FileCell class];
}

@end
