//
//  SRCloudVC.m
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SRCloudVC.h"
#import "IncomingDataModel.h"
#import <Parse/Parse.h>
#import "FileObject.h"

@implementation SRCloudVC

@synthesize mapBG = _mapBG, swypRoomContentTV = _swypRoomContentTV, swypActivateButton = _swypActivateButton;
@synthesize swypWorkspace = _swypWorkspace, outgoingDataManager = _outgoingDataManager;
@synthesize locationManager = _locationManager;
@synthesize sectionedDataModel = _sectionedDataModel;
@synthesize fetchedRoomObjects = _fetchedRoomObjects;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (self = [super initWithNibName:nil bundle:nil]){
		
	}
	return self;
}

-(void) activateSwypButtonPressed:(id)sender{
	[[self swypWorkspace] presentContentWorkspaceAtopViewController:self];
}

-(NITableViewModel*) sectionedDataModel{
	if (_sectionedDataModel == nil){
		NSMutableArray	* sectionArray	=	[[NSMutableArray alloc] init];
		
		[sectionArray addObject:LocStr(@"Nearby files", @"on main file screen")];
		[sectionArray addObjectsFromArray:[self fetchedRoomObjects]];
		_sectionedDataModel	=	[[NITableViewModel alloc] initWithSectionedArray:sectionArray delegate:(id)[NICellFactory class]];
	}
	return _sectionedDataModel;
}

-(void) beginFetchingPFItems{
	@autoreleasepool {
		
		PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];

		PFQuery *query = [PFQuery queryWithClassName:@"RoomObject"];
		[query whereKey:@"location" nearGeoPoint:geoPoint];
		query.limit = [NSNumber numberWithInt:20];
		
		NSMutableArray * parseObjectItemArray	=	[NSMutableArray array];
		for (PFObject *item in [query findObjects]){
			[parseObjectItemArray addObject:[[FileObject alloc] initWithParseObject:item]];
		}
		
		[self performSelectorOnMainThread:@selector(setFetchedRoomObjects:) withObject:parseObjectItemArray waitUntilDone:TRUE];
	}
}

-(void) setFetchedRoomObjects:(NSArray *)fetchedRoomObjects{
	_fetchedRoomObjects = fetchedRoomObjects;
	if (_fetchedRoomObjects){
		_sectionedDataModel = nil;
		[[self swypRoomContentTV] setDataSource:[self sectionedDataModel]];
		[[self swypRoomContentTV] reloadData];
	}
}

-(void) viewDidLoad{
	[super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1; // in meters
    [self.locationManager startUpdatingLocation];
	
	_swypWorkspace			=	[[swypWorkspaceViewController alloc] init];
	_outgoingDataManager	=	[[SROutgoingDataManager alloc] init];
	[_outgoingDataManager setLocationManager:[self locationManager]];
	[_swypWorkspace setContentDataSource:_outgoingDataManager];
	
	_mapBG = [[MKMapView alloc] initWithFrame:self.view.bounds];
	[_mapBG setAlpha:1];
	[_mapBG showsUserLocation];
	[_mapBG setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
	[_mapBG setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:_mapBG];
	
	//add tableview here
    
    _swypRoomContentTV		=	[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
	[_swypRoomContentTV setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.85]];
	[_swypRoomContentTV setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
	[self.view addSubview:_swypRoomContentTV];
    
    // activate swyp
	
	_swypActivateButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *	swypActivateImage	=	[UIImage imageNamed:@"swypPhotosHud"];
	[_swypActivateButton setBackgroundImage:swypActivateImage forState:UIControlStateNormal];
	[_swypActivateButton setSize:[swypActivateImage size]];
	[_swypActivateButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_swypActivateButton setFrame:CGRectMake(((self.view.width/2)-_swypActivateButton.size.width/2), self.view.height-_swypActivateButton.size.height, _swypActivateButton.size.width, _swypActivateButton.size.height)];
	
	[_swypActivateButton addTarget:self action:@selector(activateSwypButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activateSwypButtonPressed:)];
	swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[_swypActivateButton addGestureRecognizer:swipeUpRecognizer];

	[self.view addSubview:_swypActivateButton];
	
	//SO that overlaps don't occur btw button and bottom of TVC
	[[self swypRoomContentTV] setContentInset:UIEdgeInsetsMake(0, 0, 75, 0)];

}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

-(void) viewWillAppear:(BOOL)animated {
    self.title = @"Swyp to Room";
    
    [self _updateLoginButton];
}

#pragma Handling Location updates

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"Updated location.");
    
	[NSThread detachNewThreadSelector:@selector(beginFetchingPFItems) toTarget:self withObject:nil];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Oh shit. %@", error);
}


#pragma Logging in

-(void) _updateLoginButton {
    if (![PFUser currentUser]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStyleBordered target:self action:@selector(loginToFacebook)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleDone target:self action:@selector(logOut)];
    }
}

-(void) logOut {
    [PFUser logOut];
    [self _updateLoginButton];
}

-(void) loginToFacebook {
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"user_about_me",
                                 @"user_relationships", @"user_location", @"offline_access", nil];
    
    [PFUser logInWithFacebook:permissionsArray block:^(PFUser *user, NSError *error) {
        [self _updateLoginButton];
    }];
}

@end
