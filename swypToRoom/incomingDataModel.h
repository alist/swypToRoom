//
//  incomingDataModel.h
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "NITableViewModel.h"
#import <Parse/Parse.h>

@interface IncomingDataModel : NITableViewModel

@property (nonatomic, strong) NSMutableArray *items;

- (void)fetchFilesNear:(PFGeoPoint *)currentLocation;

@end
