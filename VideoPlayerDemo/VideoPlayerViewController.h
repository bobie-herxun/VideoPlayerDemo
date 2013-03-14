//
//  VideoPlayerViewController.h
//  VideoPlayerDemo
//
//  Created by BobieAir on 13/3/14.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayerViewController : UIViewController

@property (nonatomic, retain) NSString* strVideoURL;

- (IBAction)backToVideoList:(id)sender;

@end
