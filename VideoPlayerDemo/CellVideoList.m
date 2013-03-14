//
//  CellVideoList.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/14/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "CellVideoList.h"

@implementation CellVideoList

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

@end
