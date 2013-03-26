//
//  CellVideoList.h
//  VideoPlayerDemo
//
//  Created by Bobie on 3/14/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellVideoList : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imageThumbnail;
@property (retain, nonatomic) IBOutlet UILabel *labelCategory;
@property (retain, nonatomic) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) NSString* strThumbnailURL;
@property (nonatomic, retain) NSString* strVideoURL;

- (void)resetThumbnailView;
- (void)prepareThumbnail;

@end
