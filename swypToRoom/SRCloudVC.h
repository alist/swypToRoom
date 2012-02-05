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
#import "IncomingDataModel.h"

@interface SRCloudVC : UIViewController <UITableViewDelegate, NITableViewModelDelegate, CLLocationManagerDelegate> {
    UITableView * _incomingTableView;
}

@property (nonatomic,  strong) MKMapView*	mapBG;
@property (nonatomic,  strong) UITableView*	swypRoomContentTV;
@property (nonatomic, strong) UIButton *	swypActivateButton;
@property (nonatomic, strong) swypWorkspaceViewController	* swypWorkspace;
@property (nonatomic, strong) SROutgoingDataManager *	outgoingDataManager;
@property (nonatomic, strong) IncomingDataModel *incomingDataModel;
@property (nonatomic, strong) CLLocationManager *locationManager;

-(void) _updateLoginButton;

@end
