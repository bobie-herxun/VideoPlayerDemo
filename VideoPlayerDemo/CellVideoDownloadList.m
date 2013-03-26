//
//  CellVideoDownloadList.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/26/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "CellVideoDownloadList.h"

@implementation CellVideoDownloadList

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_btnPlay release];
    [super dealloc];
}

- (IBAction)btnPlayClicked:(id)sender {
    //NSString* bundlePath = [NSString stringWithFormat:@"%@/VideoPlayerDemo", [[NSBundle mainBundle] bundlePath]];
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundle root: %@", bundlePath);
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray* dirContents = [fm contentsOfDirectoryAtPath:bundlePath error:nil];
    
    NSLog(@"bundle contents: %@", dirContents);
}

@end
