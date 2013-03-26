//
//  DownloadTableViewController.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/26/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "CellVideoDownloadList.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startDownload:(NSMutableDictionary*)videoInfo andThumbnail:(UIImage*)image
{
    NSLog(@"DownloadTableViewController, startDownload()");
    
    NSString* strFilename = [(NSString*)[videoInfo objectForKey:@"videourl"] lastPathComponent];
    self.strFilepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strFilename];
    
    NSLog(@"%@", strFilename);
    NSLog(@"%@", self.strFilepath);
    
    [videoInfo setObject:self.strFilepath forKey:@"filepath"];
    
    [m_arrayDownloadingList addObject:videoInfo];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[videoInfo objectForKey:@"videourl"]]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

#pragma mark - NSConnectionDelegates

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSNumber* num = [NSNumber numberWithLongLong:[response expectedContentLength]];
    NSLog(@"response expected: %lld", [num longLongValue]);
    
    [[NSFileManager defaultManager] createFileAtPath:self.strFilepath contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.strFilepath];
    if (self.fileHandle)
    {
        [self.fileHandle seekToEndOfFile];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    if (data)
    {
        NSLog(@"receive data length: %d", [data length]);
        if (self.fileHandle)
            [self.fileHandle seekToEndOfFile];
        
        [self.fileHandle writeData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[self.fileHandle close];
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
    return [m_arrayDownloadingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIDVideoDownloadList";
    CellVideoDownloadList *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ((indexPath.row % 2) == 0)
        [cell.contentView setBackgroundColor:[UIColor darkGrayColor]];
    else
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
    
    [cell.btnPlay setImage:[UIImage imageNamed:@"play_downloaded_up.png"] forState:UIControlStateNormal];
    [cell.btnPlay setImage:[UIImage imageNamed:@"play_downloaded_down.png"] forState:UIControlStateHighlighted];
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
    [super dealloc];
}

@end
