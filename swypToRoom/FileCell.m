//
//  FileCell.m
//  swypToRoom
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "FileCell.h"
#import "FileObject.h"
#import "NSDate+Relative.h"

@implementation FileCell
@synthesize nwImgView, nameLabel, dateLabel;
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

		self.nameLabel			=	[[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.highlightedTextColor = [UIColor whiteColor];
		[self.nameLabel setTextAlignment:UITextAlignmentLeft];
		[self.nameLabel setFont:[UIFont fontWithName:@"futura" size:16]];
		self.nameLabel.frame	=	CGRectMake(120, 30, 200, 20);
		[self.nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
		[self addSubview:self.nameLabel];

		self.dateLabel			=	[[UILabel alloc] initWithFrame:CGRectZero];
        self.dateLabel.highlightedTextColor = [UIColor whiteColor];
		[self.dateLabel setTextAlignment:UITextAlignmentLeft];
		[self.dateLabel setFont:[UIFont fontWithName:@"futura" size:14]];
		self.dateLabel.frame	=	CGRectMake(120, 54, 200, 20);
		[self.dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
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

- (BOOL)shouldUpdateCellWithObject:(FileObject *)object {
	[self.nwImgView setPathToNetworkImage:[object thumbnailURL] contentMode:UIViewContentModeScaleAspectFit];
    [self.fbImgView setPathToNetworkImage:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", 
                                           object.fbID]];
	[self.dateLabel setText:[NSString stringWithFormat:@"%@ ago", [[object uploadTime] distanceOfTimeInWordsToNow]]];
	//find the .
//	NSArray * fullScreen	=	[[object fileName] ];
    NSString *fileName = [[[[object fileName] componentsSeparatedByString:@"."] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	[self.nameLabel setText:[NSString stringWithFormat:@"%@", fileName]];
    return YES;
}


+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 100;
}

@end
