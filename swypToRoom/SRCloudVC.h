//
//  SRCloudVC.h
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SROutgoingDataManager.h"
#import <CoreLocation/CoreLocation.h>
#import "NimbusModels.h"

@interface SRCloudVC : UIViewController <UITableViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate> {
}

@property (nonatomic,  strong) MKMapView*	mapBG;
@property (nonatomic,  strong) UITableView*	swypRoomContentTV;
@property (nonatomic, strong) UIButton *	swypActivateButton;
@property (nonatomic, strong) swypWorkspaceViewController	* swypWorkspace;
@property (nonatomic, strong) SROutgoingDataManager *	outgoingDataManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSManagedObjectContext * objectContext;
@property (nonatomic, strong) NITableViewModel * sectionedDataModel;
@property (nonatomic, strong) NSArray * fetchedRoomObjects;
@property (nonatomic, strong) NSFetchedResultsController * resultsController;

-(void) reloadTableData;

-(void) _updateLoginButton;
-(NSFetchRequest*)	_newOrUpdatedFetchRequest;


@end
