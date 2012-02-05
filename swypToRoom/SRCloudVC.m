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

@implementation SRCloudVC

@synthesize mapBG = _mapBG, swypRoomContentTV = _swypRoomContentTV, swypActivateButton = _swypActivateButton;
@synthesize swypWorkspace = _swypWorkspace, outgoingDataManager = _outgoingDataManager;
@synthesize incomingDataModel = _incomingDataModel, locationManager = _locationManager;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (self = [super initWithNibName:nil bundle:nil]){
		
	}
	return self;
}

-(void) activateSwypButtonPressed:(id)sender{
	[[self swypWorkspace] presentContentWorkspaceAtopViewController:self];
}

-(void) viewDidLoad{
	[super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1; // in meters
    [self.locationManager startUpdatingLocation];
	
	_swypWorkspace			=	[[swypWorkspaceViewController alloc] init];
	_outgoingDataManager	=	[[SROutgoingDataManager alloc] init];
	[_swypWorkspace setContentDataSource:_outgoingDataManager];
	
	_mapBG = [[MKMapView alloc] initWithFrame:self.view.bounds];
	[_mapBG setAlpha:1];
	[_mapBG showsUserLocation];
	[_mapBG setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
	[_mapBG setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:_mapBG];
	
	//add tableview here
    
    _incomingTableView		=	[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
	[_incomingTableView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.85]];
	[_incomingTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    self.incomingDataModel = [[IncomingDataModel alloc] initWithDelegate:self];
    
    [_incomingTableView setDataSource:self.incomingDataModel];
    [self.view addSubview:_incomingTableView];
    
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

#pragma NIIncomingDataModel delegate methods.

-(UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel 
                  cellForTableView:(UITableView *)tableView 
                       atIndexPath:(NSIndexPath *)indexPath 
                        withObject:(id)object {
    UITableViewCell* cell = [NICellFactory tableViewModel: tableViewModel
                                         cellForTableView: tableView
                                              atIndexPath: indexPath
                                               withObject: object];
    if (nil == cell){
        // customize cell creation
    }
    return cell;
}

#pragma Handling Location updates

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"Updated location.");
    
    CLLocationCoordinate2D coord = newLocation.coordinate;
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coord.latitude longitude:coord.longitude];
    [self.incomingDataModel fetchFilesNear:geoPoint];
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
