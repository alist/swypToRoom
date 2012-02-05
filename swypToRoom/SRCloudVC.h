//
//  SRCloudVC.h
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SRCloudVC : UIViewController <UITableViewDelegate>
@property (nonatomic,  strong) MKMapView*	mapBG;
@property (nonatomic,  strong) UITableView*	swypRoomContentTV;
@property (nonatomic, strong) UIButton *	swypActivateButton;


-(void) _updateLoginButton;

@end
