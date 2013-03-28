//
//  DownloadTableViewController.h
//  VideoPlayerDemo
//
//  Created by Bobie on 3/26/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray* m_arrayVideoArchive;
    NSMutableArray* m_arrayDownloadingList;
    NSMutableArray* m_arrayAwaitingList;
}

@property (nonatomic, retain) NSString* strFilepath;
@property (nonatomic, retain) id fileHandle;

- (void)startDownload:(NSMutableDictionary*)videoInfo andThumbnail:(UIImage*)image;

@end
