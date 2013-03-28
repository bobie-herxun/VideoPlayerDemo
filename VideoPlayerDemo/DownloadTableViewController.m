//
//  DownloadTableViewController.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/26/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "CellVideoDownloadList.h"

// CoreData entity
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Videos.h"

@interface DownloadTableViewController ()

@end

@implementation DownloadTableViewController {
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setDelaysContentTouches:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    /* Integrate core-data to handle download list */
    /*
     *  Note! make sure startDownload:andThumbnail: is called before entering this view
     *  1. load whole list from DB
     *  2. sort DB list into 2 lists: downloading & awaiting
     *  3. start download
     */
    
    [self performSelectorInBackground:@selector(fetchRecordsFromDB) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startDownload:(NSMutableDictionary*)videoInfo andThumbnail:(UIImage*)image
{
    /*
        Add this record into DB
        Remember to store the image to device and use the filepath for the DB record
        Also check if this record alreay exists!
     */
    
    NSLog(@"DownloadTableViewController, startDownload()");
    
    NSString* strFilename = [(NSString*)[videoInfo objectForKey:@"videourl"] lastPathComponent];
    self.strFilepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strFilename];
    
    NSLog(@"%@", strFilename);
    NSLog(@"%@", self.strFilepath);
    
    /**************************************************************************************************************/
    
    /* Check if this record already exists in DB (by comparing "videourl") */
    NSFetchRequest* requestFetch = [[NSFetchRequest alloc] init];
    [requestFetch setPredicate:[NSPredicate predicateWithFormat:@"videourl == %@", [videoInfo objectForKey:@"videourl"]]];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Videos"
                                              inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [requestFetch setEntity:entity];
    NSError* error = nil;
    NSArray* returnObjs = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:requestFetch error:&error];
    [requestFetch release];
    
    if ([returnObjs count])
        return;
    
    /* Store this thumbnail as local file, so we can use the filepath for core-data */
    NSString* strThumbnailFilename = [strFilename stringByDeletingPathExtension];
    strThumbnailFilename = [strThumbnailFilename stringByAppendingPathExtension:@"png"];
    NSData* binaryImage = UIImagePNGRepresentation(image);
    [binaryImage writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strThumbnailFilename]
                  atomically:YES];
    
    /* If this is a new record, insert it into DB */
    Videos* videoToDownload = (Videos*)[NSEntityDescription insertNewObjectForEntityForName:@"Videos"
                                                                     inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    
    videoToDownload.title = [videoInfo objectForKey:@"title"];
    videoToDownload.videourl = [videoInfo objectForKey:@"videourl"];
    videoToDownload.filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strFilename];
    videoToDownload.thumbnailFilepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strThumbnailFilename];
    videoToDownload.downloadProgress = @0.0f;
    
    if (![[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error])
        NSLog(@"Fail to insert video-to-download record into DB");

    /* Last bu not least, let's start download the video */
    [self addIntoDownloadChain:videoToDownload];
}

- (void)addIntoDownloadChain:(Videos*)videoToDownload
{
    if (!m_arrayConnectionHandleProgress)
        m_arrayConnectionHandleProgress = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:videoToDownload.videourl]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [[NSFileManager defaultManager] createFileAtPath:videoToDownload.filepath
                                            contents:nil
                                          attributes:nil];
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:videoToDownload.filepath];
    
    NSNumber* currentSize = [NSNumber numberWithLongLong:0];
    NSString* filename = [videoToDownload.filepath lastPathComponent];
    NSMutableDictionary* dictVideoToDownload = [NSMutableDictionary dictionaryWithObjects:@[ filename, connection, fileHandle, currentSize ]
                                                                                  forKeys:@[ @"filename", @"connection", @"handle", @"currentsize" ]];
    
    [m_arrayConnectionHandleProgress addObject:dictVideoToDownload];
    
    [connection start];
}

- (void)shutdownDownloadChain
{
    /* pause all NSURLConnections */
    /* close all file handles */
    /* refresh records in DB */
}

- (void)fetchRecordsFromDB
{
    /* Fill in 3 lists: m_arrayVideoArchive, m_arrayDownloadingList, m_arrayAwaitingList*/
    if (!m_arrayVideoArchive)
        m_arrayVideoArchive = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (!m_arrayDownloadingList)
        m_arrayDownloadingList = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (!m_arrayAwaitingList)
        m_arrayAwaitingList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSFetchRequest* requestFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Videos"
                                              inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [requestFetch setEntity:entity];
    NSError* error = nil;
    NSArray* returnObjs = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:requestFetch error:&error];
    [requestFetch release];
    
    for (Videos* video in returnObjs)
    {
        if ([video.downloadProgress floatValue] > 0.0f && [video.downloadProgress floatValue] < 100.0f)
            [m_arrayAwaitingList addObject:video];
        
        [m_arrayVideoArchive addObject:video];
    }
    
    /* notify main-thread to reload table data */
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)updateCellProgress:(float)fProgress withFilename:(NSString*)strFilename
{
    NSIndexPath* indexPath;
    for (int i = 0; i < [m_arrayVideoArchive count]; ++i)
    {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        CellVideoDownloadList* downloadCell = (CellVideoDownloadList*)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([downloadCell.strFilename isEqualToString:strFilename])
        {
            [downloadCell.progressDownload setProgress:fProgress];
            
            NSLog(@"progress: %3.2f", fProgress);
            if (fProgress >= 1.0f)
            {
                [downloadCell.btnPlay setEnabled:YES];
            }
        }
    }
}

- (void)cleanUpAndRefreshDB
{
    
}

#pragma mark - NSConnectionDelegates

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    for (NSMutableDictionary* connectionHandleProgress in m_arrayConnectionHandleProgress)
    {
        NSURLConnection* myConnection = [connectionHandleProgress objectForKey:@"connection"];
        if (myConnection == connection)
        {
            NSFileHandle* fileHandle = [connectionHandleProgress objectForKey:@"handle"];
            if (fileHandle)
                [fileHandle seekToEndOfFile];
            
            NSNumber* num = [NSNumber numberWithLongLong:[response expectedContentLength]];
            [connectionHandleProgress setValue:num forKey:@"expectedsize"];
            
            break;
        }
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    for (NSMutableDictionary* connectionHandleProgress in m_arrayConnectionHandleProgress)
    {
        NSURLConnection* myConnection = [connectionHandleProgress objectForKey:@"connection"];
        if (myConnection == connection)
        {
            NSFileHandle* fileHandle = [connectionHandleProgress objectForKey:@"handle"];
            if (fileHandle)
            {
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:data];
            }
            
            NSNumber* currentSize = [connectionHandleProgress objectForKey:@"currentsize"];
            currentSize = [NSNumber numberWithLongLong:[currentSize intValue] + [data length]];
            
            [connectionHandleProgress setValue:currentSize forKey:@"currentsize"];
            
            NSNumber* expectedSize = [connectionHandleProgress objectForKey:@"expectedsize"];
            float fProgress = [currentSize floatValue] / [expectedSize floatValue];
            
            /* Notify UI to update progress */
            [self updateCellProgress:fProgress withFilename:[connectionHandleProgress objectForKey:@"filename"]];
            
            break;
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    for (NSMutableDictionary* connectionHandleProgress in m_arrayConnectionHandleProgress)
    {
        NSURLConnection* myConnection = [connectionHandleProgress objectForKey:@"connection"];
        if (myConnection == connection)
        {
            NSFileHandle* fileHandle = [connectionHandleProgress objectForKey:@"handle"];
            if (fileHandle)
            {
                [fileHandle closeFile];
            }
            
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [m_arrayVideoArchive count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIDVideoDownloadList";
    CellVideoDownloadList *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ((indexPath.row % 2) == 0)
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0]];
    else
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
    
    Videos* currentVideo = [m_arrayVideoArchive objectAtIndex:indexPath.row];
    
    cell.imageThumbnail.image = [UIImage imageWithContentsOfFile:currentVideo.thumbnailFilepath];
    cell.labelTitle.text = currentVideo.title;
    [cell.progressDownload setProgress:[currentVideo.downloadProgress floatValue]];
    
    [cell.btnPlay setImage:[UIImage imageNamed:@"play_downloaded_up.png"] forState:UIControlStateNormal];
    [cell.btnPlay setImage:[UIImage imageNamed:@"play_downloaded_down.png"] forState:UIControlStateHighlighted];
    //[cell.btnPlay setEnabled:([currentVideo.downloadProgress floatValue] == 100.0f)? YES : NO ];
    cell.strFilename = [currentVideo.filepath lastPathComponent];

    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [self cleanUpAndRefreshDB];
    [super dealloc];
}

@end
