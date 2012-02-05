//
//  FileObject.h
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "NimbusModels.h"

/***
 Parse object structure of contents:
 
 [parseObject objectForKey:@"user"] -- pfstring
 [parseObject objectForKey:@"file"] -- pffile
 [parseObject objectForKey:@"thumbnail"] --pffile
 [parseObject objectForKey:@"location"] -- pfgeo
 [newRoomObject setObject:[[PFUser currentUser] facebookId] forKey:@"userFBId"];
 */

@interface FileObject : NSObject <NICellObject>

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSDate * uploadTime;
@property (nonatomic, strong) NSString *fbName;
@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, strong) PFObject *parseObject;

-(id)initWithParseObject:(PFObject *)pObject;

@end
