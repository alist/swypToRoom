//
//  SROutgoingDataManager.h
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SRSwypObjectEncapuslation : NSObject
@property (nonatomic, strong) NSData *	objectData;
@property (nonatomic, strong) UIImage *	objectIcon;
@property (nonatomic, strong) NSString*	objectUTI;
@property (nonatomic, strong) NSString*	objectName;

@end

@interface SROutgoingDataManager : NSObject <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate,UIDocumentInteractionControllerDelegate>{
	NSMutableDictionary * _outgoingObjectsByID; //SRSwypObjectEncapuslation(s)
}
@property (nonatomic, weak)	id<swypContentDataSourceDelegate> datasourceDelegate;
@property (nonatomic, strong) CLLocationManager * locationManager;

-(void) addDocumentFromURL:(NSURL*)documentURL;

///at least 200X200
-(void) addObjectWithIcon:(UIImage*)iconImage mimeSwypFileType:(NSString*)mime objectData:(NSData*)objectData;

//private
-(NSString*) _generateUniqueContentID;
-(UIImage*)	_generateIconImageForImageData:(NSData*)imageData maxSize:(CGSize)maxSize;
@end
