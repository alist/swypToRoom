//
//  SRCloudVC.m
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SRCloudVC.h"
#import <Parse/Parse.h>

@implementation SRCloudVC
@synthesize mapBG = _mapBG, swypRoomContentTV = _swypRoomContentTV, swypActivateButton = _swypActivateButton;


-(void) activateSwypButtonPressed:(id)sender{
	[[swypWorkspaceViewController sharedSwypWorkspace] presentContentWorkspaceAtopViewController:self];
}

-(void) viewDidLoad{
	[super viewDidLoad];
	
	_mapBG = [[MKMapView alloc] initWithFrame:self.view.bounds];
	[_mapBG setAlpha:1];
	[_mapBG showsUserLocation];
	[_mapBG setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
	[_mapBG setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:_mapBG];
	
	//add tableview here
	
	
	_swypActivateButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *	swypActivateImage	=	[UIImage imageNamed:@"swypPhotosHud"];
	[_swypActivateButton setBackgroundImage:swypActivateImage forState:UIControlStateNormal];

	_swypActivateButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
    [_swypActivateButton setFrame:CGRectMake(((self.view.width)-_swypActivateButton.size.width)/2, self.view.height-_swypActivateButton.size.height, _swypActivateButton.size.width, _swypActivateButton.size.height)];
	[_swypActivateButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];

	[_swypActivateButton addTarget:self action:@selector(activateSwypButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activateSwypButtonPressed:)];
	swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[_swypActivateButton addGestureRecognizer:swipeUpRecognizer];
	
	[self.view addSubview:_swypActivateButton];
	
	//SO that overlaps don't occur btw button and bottom of TVC
	[[self swypRoomContentTV] setContentInset:UIEdgeInsetsMake(0, 0, 75, 0)];

}

@end
