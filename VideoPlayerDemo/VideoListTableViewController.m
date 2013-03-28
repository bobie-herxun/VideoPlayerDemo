//
//  VideoListTableViewController.m
//  VideoPlayerDemo
//
//  Created by BobieAir on 13/3/14.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "VideoListTableViewController.h"
#import "CellVideoList.h"
#import "NetworkManager.h"
#import "VideoPlayerViewController.h"
#import "DownloadTableViewController.h"

@interface VideoListTableViewController ()

@end

@implementation VideoListTableViewController

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
    if (!m_arrayVideoList)
        m_arrayVideoList = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (!m_arrayDownloadList)
        m_arrayDownloadList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.tableView setDelaysContentTouches:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self performSelector:@selector(loadNTVNewsList) withObject:nil afterDelay:0.5f];
}

- (void)loadNTVNewsList
{
    [m_arrayVideoList removeAllObjects];
    
    NSLog(@"送HTTP Request去NTV server要news video list feed");
    NSString* strAPIURL = @"http://ews.nexttv.com.tw/pgm/getntvpgmdetails/pgmid/15470966/num/15/";
    [NetworkManager sendRequestGet:strAPIURL withPayload:nil completeCallback:^(NSData *data) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary* articles = [dict objectForKey:@"articles"];
        for (NSDictionary* video in articles)
        {
            NSString* videoUrl = [[[[video objectForKey:@"videos"] objectForKey:@"mobile_video"] objectAtIndex:0] objectForKey:@"mobilevideourl"];
            
            NSArray* arrayObjects = @[ [video objectForKey:@"artid"], [video objectForKey:@"arturl"], [video objectForKey:@"title"],
                                       [video objectForKey:@"timestamp"], [video objectForKey:@"text"], [[video objectForKey:@"pic"] objectForKey:@"w300h170"],
                                       videoUrl ];
            NSArray* arrayKeys = @[ @"artid", @"arturl", @"title", @"timestamp", @"text", @"thumbnail", @"videourl" ];
            
            NSDictionary* newVideo = [[NSDictionary alloc] initWithObjects:arrayObjects forKeys:arrayKeys];
            
            [m_arrayVideoList addObject:newVideo];
            [newVideo release];
        }

        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
    }];
}

- (void)updateTableView
{
    NSLog(@"Prepare to update table");
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueVideoPlayer"])
    {
        VideoPlayerViewController* playerViewController = segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        if ([self.tableView indexPathForSelectedRow].section == 2)
            playerViewController.strVideoURL = [[m_arrayVideoList objectAtIndex:indexPath.row] objectForKey:@"videourl"];
        else
            playerViewController.strVideoURL = @"http://iphonestream.nexttv.com.tw/iphone/mbr.m3u8";
    }
    if ([segue.identifier isEqualToString:@"segueAddDownload"])
    {
        NSLog(@"segueAddDownload");
        DownloadTableViewController* downloadTableViewController = segue.destinationViewController;
        NSIndexPath* indexPath = ((DownloadVideoButton*)sender).parentCellIndexPath;
        if (indexPath.section == 2)
        {
            NSString* strFilename = [(NSString*)[[m_arrayVideoList objectAtIndex:indexPath.row] objectForKey:@"videourl"] lastPathComponent];
            NSString* strFilepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strFilename];
            NSMutableDictionary* dictVideoToDownload = [[m_arrayVideoList objectAtIndex:indexPath.row] mutableCopy];
            [dictVideoToDownload setObject:strFilepath forKey:@"filepath"];
            [m_arrayDownloadList addObject:dictVideoToDownload];
            NSLog(@"video dict: %@", dictVideoToDownload);
            
            [downloadTableViewController startDownload:[[m_arrayVideoList objectAtIndex:indexPath.row] mutableCopy]
                                          andThumbnail:((CellVideoList*)([self.tableView cellForRowAtIndexPath:indexPath])).imageThumbnail.image];
            
            [dictVideoToDownload release];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0 || section == 1)
        return 1;
    else
        return [m_arrayVideoList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 44.0f;
    else
        return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    CellVideoList *cell;

    if (indexPath.section == 0)
    {
        CellIdentifier = @"CellIDVideoList_downloadlist";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.contentView setBackgroundColor:[UIColor darkGrayColor]];
    }
    else if (indexPath.section == 1)
    {
        CellIdentifier = @"CellIDVideoList_playlist";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.labelCategory.text = @"《即時》";
        cell.labelTitle.text = @"即時線上新聞轉播";
        cell.strVideoURL = @"https://www.youtube.com/v/u1zgFlCw8Aw?version=3&autoplay=1"; //@"http://iphonestream.nexttv.com.tw/iphone/mbr.m3u8";
    }
    else
    {
        CellIdentifier = @"CellIDVideoList";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if ([m_arrayVideoList count])
        {
            cell.labelCategory.text = @"《新聞》";
            cell.labelTitle.text = [[m_arrayVideoList objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.strThumbnailURL = [[m_arrayVideoList objectAtIndex:indexPath.row] objectForKey:@"thumbnail"];
            cell.strVideoURL = [[m_arrayVideoList objectAtIndex:indexPath.row] objectForKey:@"videourl"];
            [cell.btnDownload setImage:[UIImage imageNamed:@"download_up.png"] forState:UIControlStateNormal];
            [cell.btnDownload setImage:[UIImage imageNamed:@"download_down.png"] forState:UIControlStateHighlighted];
            cell.btnDownload.parentCellIndexPath = indexPath;
        }
        
        [cell prepareThumbnail];
    }

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

@end
