//
//  FileObject.h
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimbusModels.h"

@interface FileObject : NSObject <NICellObject>

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSDate *uploadTime;
@property (nonatomic, strong) NSString *fbName;
@property (nonatomic, strong) NSString *fbID;

@end
