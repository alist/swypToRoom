//
//  main.m
//  swypToRoom
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "SRAppDelegate.h"

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"q3FiX8q6K5ajET6MFdRwSh2icYgS93TiH5jaqOpb" 
                  clientKey:@"eZVynljiAJID7xT6lq806fpQa642kjm1r7fh8gJk"];
    
	@autoreleasepool {
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([SRAppDelegate class]));
	}
}
