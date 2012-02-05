//
//  SavedRoomObject.h
//  swypToRoom
//
//  Created by Alexander List on 2/5/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FileObject.h"

@interface SRSavedRoomFile : NSManagedObject <NICellObject> {
    NSData *_thumbnailJPGData;
    NSData *_fileData;
}

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSData * thumbnailJPGData;
@property (nonatomic, retain) NSData * fileData;
@property (nonatomic, retain) NSString * fileCreatorFBId;
@property (nonatomic, assign) float progress;

-(void) prefillFromFileObject:(FileObject*)object;
-(void) setThumbnailJPGData:(NSData *)thumbnailJPGData;
-(void) setFileData:(NSData *)fileData;

-(void) _fetchDataFromURLSInDictionary:(NSDictionary*)urlDict;

@end
