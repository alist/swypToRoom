//
//  FileCell.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "FileCell.h"
#import "FileObject.h"

@implementation FileCell
@synthesize nwImgView, nameLabel, dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		UIView * bgView		=	[[UIView alloc] initWithFrame:self.bounds];
		self.nwImgView		=	[[NINetworkImageView alloc]	initWithFrame:CGRectInset(bgView.frame, 20, 10)];
		[self.nwImgView setFrame:CGRectMake(20, 5, 150, 90)];
		[self.nwImgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleRightMargin];
		[bgView addSubview:self.nwImgView];

		self.nameLabel			=	[[UILabel alloc] initWithFrame:CGRectZero];
		self.nameLabel.size		=	CGSizeMake(100, 40);
		[self.nameLabel setTextAlignment:UITextAlignmentRight];
		[self.nameLabel setFont:[UIFont fontWithName:@"futura" size:12]];
		self.nameLabel.origin	=	CGPointMake(self.width -self.nameLabel.size.width, 10);
		[self.nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
		[bgView addSubview:self.nameLabel];

		self.dateLabel			=	[[UILabel alloc] initWithFrame:CGRectZero];
		self.dateLabel.size		=	CGSizeMake(100, 40);
		[self.dateLabel setTextAlignment:UITextAlignmentRight];
		[self.dateLabel setFont:[UIFont fontWithName:@"futura" size:12]];
		self.dateLabel.origin	=	CGPointMake(self.width -self.nameLabel.size.width, 60);
		[self.dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
		[bgView addSubview:self.dateLabel];
		
		[self setBackgroundView:bgView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)shouldUpdateCellWithObject:(FileObject *)object {
	[self.nwImgView setPathToNetworkImage:[object thumbnailURL] contentMode:UIViewContentModeScaleAspectFit];
	[self.dateLabel setText:[[object uploadTime] description]];
	//find the .
//	NSArray * fullScreen	=	[[object fileName] ];
	[self.nameLabel setText:[object fileName]];
    return YES;
}


+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 100;
}

@end
