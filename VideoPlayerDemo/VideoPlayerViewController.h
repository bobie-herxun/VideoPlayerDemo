//
//  VideoPlayerViewController.h
//  VideoPlayerDemo
//
//  Created by BobieAir on 13/3/14.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController : UIViewController

@property (nonatomic, retain) MPMoviePlayerController* player;
@property (nonatomic, retain) NSString* strVideoURL;
@property (nonatomic, assign) BOOL bPlayLocalFile;

- (IBAction)backToVideoList:(id)sender;

@end
