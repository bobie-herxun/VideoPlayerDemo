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

- (void)dealloc {
    [_imageThumbnail release];
    [_labelCategory release];
    [_labelTitle release];
    [super dealloc];
}

- (void)refreshVideoThumbnail
{
    CGRect frame = self.imageThumbnail.frame;
    self.imageThumbnail.frame = frame;
}

- (void)prepareThumbnail
{
    if ([self.strThumbnailURL isEqualToString:@""])
        return;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strThumbnailURL]];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue completionHandler:^(NSURLResponse* response, NSData* responseData, NSError* error)
        {
            if (error)
            {
                NSLog(@"Cannot retrieve picture from URL");
            }
            else
            {
                if (responseData)
                {
                    UIImage* image = [[UIImage alloc] initWithData:responseData];
                    self.imageThumbnail.image = image;
                    [image release];
                    
                    // Rearrange text-view position, container-view frame and scroll-view frame
                    //
                    // Important!! access UI elements like assigning size or frame, should be done in main thread
                    // Else app will crash
                    //
                    [self performSelectorOnMainThread:@selector(refreshVideoThumbnail) withObject:nil waitUntilDone:NO];
                }
            }
        }];
}

@end
