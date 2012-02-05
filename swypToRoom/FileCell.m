//
//  FileCell.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "FileCell.h"

#import "NSDate+Relative.h"

@implementation FileCell
@synthesize nwImgView, nameLabel, dateLabel, usernameLabel;
@synthesize fbImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        // Initialization code
		UIView * bgView		=	[[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor clearColor];
		self.nwImgView		=	[[NINetworkImageView alloc]	initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.nwImgView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
		[self addSubview:self.nwImgView];
        
        self.fbImgView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [self.fbImgView setScaleOptions:NINetworkImageViewScaleToFitCropsExcess];
        [self addSubview:fbImgView];

		self.nameLabel			=	[[UILabel alloc] initWithFrame:CGRectMake(120, 30, 200, 20)];
        self.nameLabel.highlightedTextColor = [UIColor whiteColor];
		[self.nameLabel setTextAlignment:UITextAlignmentLeft];
		[self.nameLabel setFont:[UIFont fontWithName:@"futura" size:16]];
		[self.nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
		[self addSubview:self.nameLabel];

		self.dateLabel			=	[[UILabel alloc] initWithFrame:CGRectMake(120, 8, 192, 20)];
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.highlightedTextColor = [UIColor whiteColor];
		[self.dateLabel setTextAlignment:UITextAlignmentRight];
		[self.dateLabel setFont:[UIFont fontWithName:@"futura" size:12]];
		[self.dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
		[self addSubview:self.dateLabel];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 52, 200, 20)];
        [self.usernameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self.nameLabel setFont:[UIFont fontWithName:@"futura" size:14]];
        [self addSubview:self.dateLabel];
		
		[self setBackgroundView:bgView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)shouldUpdateCellWithObject:(id)object {
	if ([object isKindOfClass:[FileObject class]]){
		[self updateCellWithFileObject:object];	
	}else{
		[self updateCellWithSavedRoomObject:object];
	}
    return YES;
}

- (void)updateCellWithFileObject:(FileObject*)object{
	[self.nwImgView setPathToNetworkImage:[object thumbnailURL] contentMode:UIViewContentModeScaleAspectFit];
    [self.fbImgView setPathToNetworkImage:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", 
                                           object.fbID]];
   self.usernameLabel.text = object.fbName;
	self.dateLabel.text = [NSString stringWithFormat:@"%@ ago", [[object uploadTime] distanceOfTimeInWordsToNow]];
    NSString *fileName = [[[object.fileName componentsSeparatedByString:@"."] lastObject] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	self.nameLabel.text = [NSString stringWithFormat:@"%@", fileName];
    return YES;
}

- (void)updateCellWithSavedRoomObject:(SavedRoomObject*)object{
	[self.nwImgView setImage:[UIImage imageWithData:[object thumbnailJPGData]]];

	[self.fbImgView setPathToNetworkImage:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", 
                                           object.fileCreatorFBId]];

	
	[self.dateLabel setText:[NSString stringWithFormat:@"%@ ago", [[object dateAdded] distanceOfTimeInWordsToNow]]];
	
	NSString *fileName = [[[[object fileName] componentsSeparatedByString:@"."] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	[self.nameLabel setText:[NSString stringWithFormat:@"%@", fileName]];

}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 100;
}

@end
