//
//  CellVideoDownloadList.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/26/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "CellVideoDownloadList.h"
#import "DownloadTableViewController.h"

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
    [_imageThumbnail release];
    [_labelTitle release];
    [_progressDownload release];
    [super dealloc];
}

- (IBAction)btnPlayClicked:(id)sender {
    DownloadTableViewController* parentTableView;
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UITableViewController class]])
        {
            parentTableView = (DownloadTableViewController*)(nextResponder);
            parentTableView.strPlayFilepath = self.strFilepath;
            break;
        }
    }
}

@end
