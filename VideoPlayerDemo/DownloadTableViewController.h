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
    
    /* Each entry in m_arrayConnecionHandleProgress contains 4 pairs of key-value
        "connection"    NSURLConnection
        "handle"        NSFileHandle
        "currentsize"      data amount received and written into file-handle
        "expectedsize   total data amount supposed to be downloaded for this connection
     
        each entry should use the filename, like "15044723.mp4" as its key
     */
    NSMutableArray* m_arrayConnectionHandleProgress;
}

@property (nonatomic, retain) NSString* strFilepath;
@property (nonatomic, retain) id fileHandle;

- (void)startDownload:(NSMutableDictionary*)videoInfo andThumbnail:(UIImage*)image;

@end
