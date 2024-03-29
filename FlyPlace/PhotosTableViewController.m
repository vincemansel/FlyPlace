//
//  PhotosTableViewController.m
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoDetailViewController.h"

@interface PhotosTableViewController()
@property (retain, nonatomic) NSMutableArray *photosAtPlace;
@end

@implementation PhotosTableViewController

@synthesize place;
@synthesize photosAtPlace;

- (void)setPlace:(NSDictionary *)newPlace
{
    if (place != newPlace) {
        [place release];
        place = newPlace;
    }
    //NSLog(@"Location Photos: %@", [FlickrFetcher photosAtPlace:[place objectForKey:@"place_id"]]);
    self.photosAtPlace = [[[FlickrFetcher photosAtPlace:[place objectForKey:@"place_id"]] mutableCopy] retain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (PhotoDetailViewController *)photoDetailViewController
{
    if (!photoDetailViewController)
        photoDetailViewController = [[PhotoDetailViewController alloc] init];
        
    return photoDetailViewController;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    NSLog(@"PhotosTableViewController: viewDidLoad: IN");
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.photosAtPlace.count;;
}

- (NSString *)photoTitleAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.photosAtPlace objectAtIndex:indexPath.row] objectForKey:@"title"];
}

- (NSString *)photoDescriptionAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *descriptionDictionary = [[self.photosAtPlace objectAtIndex:indexPath.row] objectForKey:@"description"];
    return [descriptionDictionary objectForKey:@"_content"];
}

- (NSDictionary *)parsePhotoAtPlace:(NSIndexPath *)indexPath
{
    NSString *title = [self photoTitleAtIndexPath:indexPath];
    NSString *description = [self photoDescriptionAtIndexPath:indexPath];
    NSString *newTitle;
    
    if ([title isEqualToString:@""] && [description isEqualToString:@""])
        newTitle = @"Unknown";
    else if ([title isEqualToString:@""])
        newTitle = description;
    else
        newTitle = title;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:newTitle, @"title", description, @"subtitle", nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotosTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *cellInfo = [self parsePhotoAtPlace:indexPath];
    cell.textLabel.text = [cellInfo objectForKey:@"title"];
    cell.detailTextLabel.text = [cellInfo objectForKey:@"subtitle"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    if (photoDetailViewController) [photoDetailViewController release];
    photoDetailViewController = [[PhotoDetailViewController alloc] init];

    self.photoDetailViewController.title = [[self parsePhotoAtPlace:indexPath] objectForKey:@"title"];
    self.photoDetailViewController.flickrInfo = [[self.photosAtPlace objectAtIndex:indexPath.row] copy];
    //NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
    //NSLog(@"Location Photos: %@", [FlickrFetcher photosAtPlace:[place objectForKey:@"place_id"]]);
//    if (self.photoDetailViewController.view.window == nil) {
    [self.navigationController pushViewController:self.photoDetailViewController animated:YES];
}

- (void)dealloc
{
    [photosAtPlace release];
    [place release]; //This is a copy. The original info is actually "owned" by the PlacesTableViewController
    [PhotoDetailViewController release];
    [super dealloc];
}

@end
