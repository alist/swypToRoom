//
//  SROutgoingDataManager.m
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SROutgoingDataManager.h"
#import <QuartzCore/QuartzCore.h>
#import "SRAppDelegate.h"
#import <Parse/Parse.h>

@implementation SRSwypObjectEncapuslation
@synthesize objectData = _objectData, objectUTI = _objectUTI, objectIcon = _objectIcon, objectName = _objectName;
@end

@implementation SROutgoingDataManager
@synthesize datasourceDelegate = _datasourceDelegate;
@synthesize locationManager = _locationManager;

-(id) init{
	if (self = [super init]){
		_outgoingObjectsByID	=	[[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) addDocumentFromURL:(NSURL *)documentURL{
	UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: documentURL];
    interactionController.delegate = self;
	SRSwypObjectEncapuslation *	newObject = [SRSwypObjectEncapuslation new];
	[newObject setObjectIcon:([[interactionController icons] count] > 0)?[[interactionController icons] lastObject]:nil]; 
	[newObject setObjectName:[documentURL lastPathComponent]];
	[newObject setObjectUTI:[interactionController UTI]];
	[newObject setObjectData:[NSData dataWithContentsOfURL:documentURL options:NSDataReadingMappedIfSafe error:nil]];

	NSString * newId = [self _generateUniqueContentID];
	[_outgoingObjectsByID setValue:newObject forKey:newId];
	[_datasourceDelegate datasourceInsertedContentWithID:newId withDatasource:self];
    [self prettifyIconForObjectID:newId fromURL:documentURL];

}

-(void)prettifyIconForObjectID:(NSString*)objectID fromURL:(NSURL*)url {
    NSArray* stringArray = [NSArray arrayWithObjects:@"pdf",@"png",@"doc",@"xls",@"xlsx",@"doc",@"docx",@"ppt",@"pptx",@"jpg",@"jpeg",@"gif",@"bmp",@"html", nil];
    NSLog(@"%@",url.pathExtension);
    BOOL stringMatch = [stringArray containsObject:url.pathExtension] != NSNotFound;
    SRSwypObjectEncapuslation* object = [_outgoingObjectsByID objectForKey:objectID];
    if (stringMatch) {
        UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [wv loadRequest:[NSURLRequest requestWithURL:url]];
        SRAppDelegate* del = (((SRAppDelegate*) [UIApplication sharedApplication].delegate));
        [[del.window.subviews lastObject] addSubview:wv];
        wv.hidden = YES;
        // 5 seconds seems to be enough to render the webview ;)
        // tried using delegate but had a problem.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            wv.hidden = NO;
            UIGraphicsBeginImageContextWithOptions(wv.frame.size, YES, 0);
            [wv.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [object setObjectIcon:viewImage];
            [wv removeFromSuperview];
            // The right way to do it is make a datasourceUpdatedContentWithID or datasourceUpdatedIconForContent
            [_outgoingObjectsByID removeObjectForKey:objectID];
            [_datasourceDelegate datasourceRemovedContentWithID:objectID withDatasource:self];
            [_outgoingObjectsByID setObject:object forKey:objectID];
            [_datasourceDelegate datasourceInsertedContentWithID:objectID withDatasource:self];
        });
    }
}

-(void) addObjectWithIcon:(UIImage*)iconImage mimeSwypFileType:(NSString*)mime objectData:(NSData*)objectData{
	SRSwypObjectEncapuslation *	newObject = [SRSwypObjectEncapuslation new];
	[newObject setObjectIcon:iconImage]; 
	[newObject setObjectUTI:mime];
	[newObject setObjectName:[@"file." stringByAppendingString:[mime stringByReplacingOccurrencesOfString:@"/" withString:@"_"]]];
	[newObject setObjectData:objectData];
	
	NSString * newId = [self _generateUniqueContentID];
	[_outgoingObjectsByID setValue:newObject forKey:newId];
	
	[_datasourceDelegate datasourceInsertedContentWithID:newId withDatasource:self];

}

-(void) addObjectToRoom:(SRSwypObjectEncapuslation*)object{
	EXOLog(@"Adding object to room! %@",[object objectUTI]);
	PFObject * newRoomObject	=	[PFObject objectWithClassName:@"RoomObject"];
	PFFile * objectFile			=	[PFFile fileWithName:[object objectName] data:[object objectData]];
	PFFile * thumbail			=	[PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation([object objectIcon], .9)];
	CLLocation * lastLocation	=	[[self locationManager] location];
	PFGeoPoint * thisGeo		=	[PFGeoPoint geoPointWithLatitude:lastLocation.coordinate.latitude longitude:lastLocation.coordinate.latitude];
	[newRoomObject setObject:thisGeo forKey:@"location"];
	[newRoomObject setObject:[PFUser currentUser] forKey:@"user"];
	[newRoomObject setObject:[[PFUser currentUser] facebookId] forKey:@"userFBId"];

	[objectFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded){
			[thumbail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (succeeded){
					[newRoomObject setObject:objectFile forKey:@"file"];
					[newRoomObject setObject:thumbail forKey:@"thumbnail"];
					[newRoomObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
						if (succeeded){
							EXOLog(@"Uploaded successfully of type %@!", [object objectName]);
						}else{
							EXOLog(@"Failed upload of %@ with error %@", [object objectName], [error description]);
						}
					}];
				}else{
					EXOLog(@"Failed upload thumbail for %@ with error %@", [object objectName], [error description]);
				}
			}];
			
		}else{
			EXOLog(@"Failed upload objectFile for %@ with error %@", [object objectName], [error description]);
		}
	}];
	
}


#pragma mark - delegation
- (NSArray*)	idsForAllContent{
	return [_outgoingObjectsByID allKeys];
}
- (UIImage *)	iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{
	SRSwypObjectEncapuslation *	object		=	[_outgoingObjectsByID objectForKey:contentID];
	UIImage * icon	=	[object objectIcon]; 

	return icon;
	
}
- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return [NSArray arrayWithObjects:[NSString imagePNGFileType],[NSString imageJPEGFileType],nil];
}

- (NSData*)	dataForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type{
	
	SRSwypObjectEncapuslation *	object		=	[_outgoingObjectsByID objectForKey:contentID];
	
	UIImage * icon	=	[object objectIcon]; 
	
	NSData *	sendPhotoData	=	nil;
	if ([type isEqualToString:[swypFileTypeString imagePNGFileType]]){
		sendPhotoData	=  UIImagePNGRepresentation(icon);
	}else if ([type isEqualToString:[swypFileTypeString imageJPEGFileType]]){
		sendPhotoData	=	UIImageJPEGRepresentation(icon,.8);
	}
	
	return sendPhotoData;
}

-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)delegate{
	_datasourceDelegate	=	delegate;
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return _datasourceDelegate;
}

-(void)	contentWithIDWasDraggedOffWorkspace:(NSString*)contentID{

	if (StringHasText([[PFUser currentUser] facebookId])){
		EXOLog(@"Dragged content off! %@",contentID);
		[self addObjectToRoom:[_outgoingObjectsByID objectForKey:contentID]];
		
		[_outgoingObjectsByID removeObjectForKey:contentID];
		[_datasourceDelegate datasourceRemovedContentWithID:contentID withDatasource:self];
	}else{
		[[[UIAlertView alloc] initWithTitle:LocStr(@"Sign-In Required",@"After content swyp-to-room attempted")  message:LocStr(@"Link your facebook account from the home-screen",@"from the swyp workspace") delegate:nil cancelButtonTitle:LocStr(@"Okay",@"Dismiss alert view") otherButtonTitles:nil] show];
		[_datasourceDelegate datasourceRemovedContentWithID:contentID withDatasource:self];
		[_datasourceDelegate datasourceInsertedContentWithID:contentID withDatasource:self];

	}
}

#pragma mark swypConnectionSessionDataDelegate
-(NSArray*)supportedFileTypesForReceipt{
	return [NSArray arrayWithObjects:[NSString imageJPEGFileType] ,[NSString imagePNGFileType], nil];
}

-(BOOL) delegateWillReceiveDataFromDiscernedStream:(swypDiscernedInputStream*)discernedStream ofType:(NSString*)streamType inConnectionSession:(swypConnectionSession*)session{
	if ([[NSSet setWithArray:[swypContentInteractionManager supportedReceiptFileTypes]] containsObject:[discernedStream streamType]]){
		return TRUE;
	}else{
		return FALSE;
	}
}

-(void)	yieldedData:(NSData*)streamData discernedStream:(swypDiscernedInputStream*)discernedStream inConnectionSession:(swypConnectionSession*)session{
	EXOLog(@" datasource received data of type: %@",[discernedStream streamType]);
	
	if ([[discernedStream streamType] isFileType:[NSString imageJPEGFileType]] || [[discernedStream streamType] isFileType:[NSString imagePNGFileType]]){
		SRSwypObjectEncapuslation *	newObject = [SRSwypObjectEncapuslation new];
		[newObject setObjectIcon:[self _generateIconImageForImageData:streamData maxSize:CGSizeMake(200, 200)]]; 
		[newObject setObjectUTI:[discernedStream streamType]];
		[newObject setObjectData:streamData];
		[newObject setObjectName:[@"file." stringByAppendingString:[[discernedStream streamType] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]]];
		
		NSString * newId = [self _generateUniqueContentID];
		[_outgoingObjectsByID setValue:newObject forKey:newId];
		[_datasourceDelegate datasourceInsertedContentWithID:newId withDatasource:self];
	}
	
}


#pragma mark - private
-(UIImage*)	_generateIconImageForImageData:(NSData*)imageData maxSize:(CGSize)maxSize{
	UIImage * loadImage		=	[[UIImage alloc] initWithData:imageData];
	if (loadImage == nil)
		return nil;
	
	CGSize oversize = CGSizeMake([loadImage size].width - maxSize.width, [loadImage size].height - maxSize.height);
	
	CGSize iconSize			=	CGSizeZero;
	
	if (oversize.width > 0 || oversize.height > 0){
		if (oversize.height > oversize.width){
			double scaleQuantity	=	maxSize.height/ loadImage.size.height;
			iconSize		=	CGSizeMake(scaleQuantity * loadImage.size.width, maxSize.height);
		}else{
			double scaleQuantity	=	maxSize.width/ loadImage.size.width;	
			iconSize		=	CGSizeMake(maxSize.width, scaleQuantity * loadImage.size.height);		
		}
	}else{
		iconSize			= [loadImage size];
	}
	
	UIGraphicsBeginImageContextWithOptions(iconSize, NO, [[UIScreen mainScreen] scale]);
	[loadImage drawInRect:CGRectMake(0,0,iconSize.width,iconSize.height)];
	UIImage* cachedIconImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return cachedIconImage;
}

-(NSString*) _generateUniqueContentID{
	NSInteger idNum 	= [_outgoingObjectsByID count];
	NSString * uniqueID = [NSString stringWithFormat:@"MODEL_%i",idNum];
	while ([_outgoingObjectsByID objectForKey:uniqueID] != nil) {
		idNum ++;
		uniqueID = [NSString stringWithFormat:@"MODEL_%i",idNum];
	}
	return uniqueID;
}


@end
