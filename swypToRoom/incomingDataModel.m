//
//  incomingDataModel.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "IncomingDataModel.h"
#import "FileObject.h"

@implementation IncomingDataModel

@synthesize items = _items;

-(id)initWithDelegate:(id<NITableViewModelDelegate>)delegate {
    if (self = [super initWithDelegate:delegate]){
        self.items = [NSMutableArray array];
    }
    
    return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (self.items.count > indexPath.row){
        return [self.items objectAtIndex:indexPath.row];
    }
    
    return nil;
}

- (void)fetchFilesNear:(PFGeoPoint *)currentLocation{
    NSLog(@"Fetching files.");
    
    PFQuery *query = [PFQuery queryWithClassName:@"RoomObject"];
    [query whereKey:@"location" nearGeoPoint:currentLocation];
    query.limit = [NSNumber numberWithInt:20];
    
    for (PFObject *item in [query findObjects]){
        [self.items addObject:[[FileObject alloc] initWithParseObject:item]];
    }
    [self.items addObjectsFromArray:[query findObjects]];
    
    NSLog(@"%@", self.items);
}

@end
