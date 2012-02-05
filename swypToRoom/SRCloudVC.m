//
//  SRCloudVC.m
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SRCloudVC.h"

@implementation SRCloudVC
@synthesize mapBG = _mapBG, swypRoomContentTV = _swypRoomContentTV;

-(void) viewDidLoad{
	[super viewDidLoad];
	
	_mapBG = [[MKMapView alloc] initWithFrame:self.view.bounds];
	[_mapBG showsUserLocation];
	[_mapBG setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
	[_mapBG setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:_mapBG];
	
	//add tableview here
}

@end
