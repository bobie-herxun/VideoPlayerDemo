//
//  CellVideoDownloadList.h
//  VideoPlayerDemo
//
//  Created by Bobie on 3/26/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellVideoDownloadList : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *btnPlay;

- (IBAction)btnPlayClicked:(id)sender;

@end
