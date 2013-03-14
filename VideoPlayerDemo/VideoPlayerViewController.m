//
//  VideoPlayerViewController.m
//  VideoPlayerDemo
//
//  Created by BobieAir on 13/3/14.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self prepareVideoPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareVideoPlayer
{
    MPMoviePlayerController* player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.strVideoURL]];
    CGRect frame = CGRectMake(10, 10, 300, 200);;
    player.view.frame = frame;
    
    [self.view addSubview:player.view];
    
    player.movieSourceType = MPMovieSourceTypeFile;
    
    [player setFullscreen:YES animated:YES];
    [player prepareToPlay];
    [player play];
}

- (IBAction)backToVideoList:(id)sender {
    //[self presentViewController:[self presentingViewController] animated:YES completion:nil];
    [self dismissModalViewControllerAnimated:YES];
}
@end
