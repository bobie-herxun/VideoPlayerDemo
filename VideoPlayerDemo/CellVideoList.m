//
//  CellVideoList.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/14/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "CellVideoList.h"

@implementation CellVideoList {
    BOOL m_bLoaded;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        m_bLoaded = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imageThumbnail release];
    [_labelCategory release];
    [_labelTitle release];
    [_btnDownload release];
    [super dealloc];
}

- (void)refreshVideoThumbnail:(NSData*)imageData
{
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    self.imageThumbnail.image = image;
    [image release];
}

- (void)prepareThumbnail
{
    if ([self.strThumbnailURL isEqualToString:@""])
        return;
    
    if (m_bLoaded)
        return;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strThumbnailURL]];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse* response, NSData* responseData, NSError* error)
        {
            if (error)
            {
                NSLog(@"Cannot retrieve picture from URL");
            }
            else
            {
                if (responseData)
                {                    
                    [self performSelectorOnMainThread:@selector(refreshVideoThumbnail:) withObject:responseData waitUntilDone:NO];
                }
            }
        }];
}

@end
