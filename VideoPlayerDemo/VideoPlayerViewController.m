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
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.strVideoURL]];
    CGRect frame = CGRectMake(10, 10, 300, 200);;
    self.player.view.frame = frame;
    
    [self.view addSubview:self.player.view];
    
    NSString* ext = [self.strVideoURL pathExtension];
    if ([ext isEqualToString:@"m3u8"])
        self.player.movieSourceType = MPMovieSourceTypeStreaming;
    else
        self.player.movieSourceType = MPMovieSourceTypeFile;
    
    [self initPlayerNotifications];
    
    [self.player setFullscreen:YES animated:YES];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)initPlayerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlaybackStateChange)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoadStateChanged)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlaybackDidFinished)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

#pragma mark - State-aware notifications
- (void)onPlaybackStateChange
{
    NSLog([NSString stringWithFormat:@"playbackstate: %d", [self.player playbackState]]);
    if ([self.player playbackState] == MPMoviePlaybackStateStopped)
    {
        if (self.player.fullscreen)
            [self.player setFullscreen:NO];
    }
}

- (void)onLoadStateChanged
{
    NSLog([NSString stringWithFormat:@"loadstate: %d", [self.player loadState]]);
    if ([self.player loadState] == MPMovieLoadStatePlayable)
    {
        [self.player setFullscreen:YES];
    }
}

- (void)onPlaybackDidFinished
{
    if (self.player.fullscreen)
        [self.player setFullscreen:NO animated:YES];
    
    [self backToVideoList:nil];
}

- (IBAction)backToVideoList:(id)sender {
    [self.player release];
    [self dismissModalViewControllerAnimated:YES];
}
@end
