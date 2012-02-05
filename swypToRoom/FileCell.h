//
//  FileCell.h
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"
#import "NINetworkImageView.h"
#import "FileObject.h"
#import "SRSavedRoomFile.h"


@interface FileCell : UITableViewCell <NICell>

@property (nonatomic, strong) NINetworkImageView * nwImgView;
@property (nonatomic, strong) NINetworkImageView * fbImgView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * dateLabel;

- (void)updateCellWithSavedRoomObject:(SRSavedRoomFile*)object;
- (void)updateCellWithFileObject:(FileObject*)object;
@property (nonatomic, strong) UILabel * usernameLabel;

@end
