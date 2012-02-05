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

@interface SRCloudVC : UIViewController <UITableViewDelegate>
@property (nonatomic,  strong) MKMapView*	mapBG;
@property (nonatomic,  strong) UITableView*	swypRoomContentTV;
@property (nonatomic, strong) UIButton *	swypActivateButton;
@property (nonatomic, strong) swypWorkspaceViewController	* swypWorkspace;
@property (nonatomic, strong) SROutgoingDataManager *	outgoingDataManager;


-(void) _updateLoginButton;

@end
