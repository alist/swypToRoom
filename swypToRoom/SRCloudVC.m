//
//  SRCloudVC.m
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SRCloudVC.h"
#import <Parse/Parse.h>
#import "FileObject.h"
#import "SavedRoomObject.h"

@implementation SRCloudVC

@synthesize mapBG = _mapBG, swypRoomContentTV = _swypRoomContentTV, swypActivateButton = _swypActivateButton;
@synthesize swypWorkspace = _swypWorkspace, outgoingDataManager = _outgoingDataManager;
@synthesize locationManager = _locationManager;
@synthesize sectionedDataModel = _sectionedDataModel;
@synthesize fetchedRoomObjects = _fetchedRoomObjects;
@synthesize resultsController = _resultsController;

@synthesize objectContext = _objectContext;

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
		
		[sectionArray addObject:LocStr(@"nearby files", @"on main file screen")];
		[sectionArray addObjectsFromArray:[self fetchedRoomObjects]];
		[sectionArray addObject:LocStr(@"downloaded files",@"On main view for people to view stuff received")];
		NSArray	* historyItems			= [[self resultsController] fetchedObjects];
		[sectionArray addObjectsFromArray:historyItems];

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
		[query orderByDescending:@"createdAt"];
		
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
		[self reloadTableData];
	}
}

-(void) reloadTableData{
	_sectionedDataModel = nil;
	[[self swypRoomContentTV] setDataSource:[self sectionedDataModel]];
	[[self swypRoomContentTV] reloadData];

}

-(void) fetchItemsInBackground {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self beginFetchingPFItems];
    });
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
	[_swypRoomContentTV setDelegate:self];
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
	
    [NSTimer scheduledTimerWithTimeInterval:3 target:self  selector:@selector(fetchItemsInBackground) userInfo:nil repeats:YES];
	
	NSError *error = nil;
	[[self resultsController] performFetch:&error];
	if (error != nil){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[NSException exceptionWithName:[error domain] reason:[error description] userInfo:nil];
	}	
	[self reloadTableData];
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

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height	=	0;
	
	id object  =  [(NITableViewModel*)[tableView dataSource] objectAtIndexPath:indexPath];
	id class	=	[object cellClass];
	if ([class respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]){
		height	=	[class heightForObject:object atIndexPath:indexPath tableView:tableView];
	}
	return height;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if (indexPath.section == 0){
		//instantiate a download
		SavedRoomObject * newRoomObject = [NSEntityDescription insertNewObjectForEntityForName:@"SavedRoomObject" inManagedObjectContext:[self objectContext]];
		[newRoomObject prefillFromFileObject:[(NITableViewModel*)[tableView dataSource] objectAtIndexPath:indexPath]];
	}
}

#pragma mark NSFetchedResultsController


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
	[self reloadTableData];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
	
    if (type == NSFetchedResultsChangeInsert){
		//		[_swypHistoryTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }else if (type == NSFetchedResultsChangeMove){
	}else if (type == NSFetchedResultsChangeUpdate){
	}else if (type == NSFetchedResultsChangeDelete){
	}
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
}

-(NSFetchRequest*)	_newOrUpdatedFetchRequest{
	NSFetchRequest* request = nil;
	request = _resultsController.fetchRequest;
	
	if (request == nil){
		NSEntityDescription *requestEntity =	[NSEntityDescription entityForName:@"SavedRoomObject" inManagedObjectContext:_objectContext];
		
		request = [[NSFetchRequest alloc] init];
		[request setEntity:requestEntity];
		[request setFetchLimit:20];
	}
	
	NSSortDescriptor *dateSortOrder = [[NSSortDescriptor alloc] initWithKey:@"dateAdded" ascending:FALSE];
	[request setSortDescriptors:[NSArray arrayWithObjects:dateSortOrder, nil]];
	
	return request;
}
-(NSFetchedResultsController*)resultsController{
	if (_resultsController == nil){
		NSFetchRequest *request = [self _newOrUpdatedFetchRequest];
		_resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_objectContext sectionNameKeyPath:nil cacheName:nil];
		[_resultsController setDelegate:self];
	}
	return _resultsController;
}



@end
