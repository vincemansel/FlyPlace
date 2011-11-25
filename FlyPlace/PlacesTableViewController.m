//
//  PlacesTableViewController.m
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosTableViewController.h"

@interface PlacesTableViewController()
@property (retain, nonatomic) NSMutableDictionary *topPlaces;
@property (retain, nonatomic) NSMutableDictionary *sectionDictionary;

- (NSDictionary *)parseLabel:(NSString *)label;

@end

@implementation PlacesTableViewController

@synthesize topPlaces, sectionDictionary;
@synthesize detailViewController;

/* Sample Code from TableViewSuite>CustomTableViewCell>CustomTableViewCellAppDelegate>displayList
 
 // Sort the regions
 NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
 NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
 [regions sortUsingDescriptors:sortDescriptors];
 [sortDescriptor release];
 
 */
 

- (NSMutableArray *)fetchTopPlacesFromFlickr
{
    NSMutableArray *topFetchedPlaces = [[NSMutableArray arrayWithArray:[FlickrFetcher topPlaces]] retain];
    topFetchedPlaces = [[topFetchedPlaces sortedArrayUsingDescriptors:
                  [NSArray arrayWithObject:
                   [NSSortDescriptor sortDescriptorWithKey:@"_content" ascending:YES]]] mutableCopy];
    
    
    return [topFetchedPlaces autorelease];
}

- (NSMutableDictionary *)topPlaces
{
    if (!topPlaces) topPlaces = [[NSMutableDictionary alloc] init];
    return topPlaces;
}

/*
 * Construct an alphabetical index list with the number of places per index
 */

- (NSMutableDictionary *)sectionDictionary
{
    if (!sectionDictionary)
    {
        sectionDictionary = [[NSMutableDictionary alloc] init];
        NSMutableString *ch;
        NSMutableDictionary *cellLabel;
        
        for (NSDictionary *place in [self fetchTopPlacesFromFlickr]) {
            cellLabel = [[self parseLabel:[place objectForKey:@"_content"]] mutableCopy];
            ch = [[[cellLabel objectForKey:@"title"] substringToIndex:1] mutableCopy];
            
            BOOL found = NO;
            
            for (NSString *str in [sectionDictionary allKeys]) {
                if ([str isEqualToString:ch]) {
                    found = YES;
                    break;
                }
            }
            if (!found) {
                [sectionDictionary setObject:[NSNumber numberWithInt:1] forKey:ch];
                [self.topPlaces setObject:[NSMutableArray arrayWithObject:place] forKey:ch];
            }
            else {
                NSInteger count = [[sectionDictionary objectForKey:ch] integerValue] + 1;
                [sectionDictionary setObject:[NSNumber numberWithInt:count] forKey:ch];
                [[self.topPlaces objectForKey:ch] addObject:place];
            }
        }
        [ch release]; [cellLabel release];
    }
    return sectionDictionary;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //[self setup];
    }
    return self;
}
//- (void)awakeFromNib
//{
//    //[self setup];
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (PhotosTableViewController *)locationPhotosTVC
{
    if (!locationPhotosTVC) locationPhotosTVC = [[PhotosTableViewController alloc] init];
    return locationPhotosTVC;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    NSLog(@"PlacesTableViewController: viewDidLoad: IN");
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.sectionDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionKey = [[[self.sectionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
    return [[self.sectionDictionary objectForKey:sectionKey] integerValue];
}

- (NSDictionary *)topPlaceInfoAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [[[self.sectionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section];
    NSArray *placesInSection = [self.topPlaces objectForKey:sectionKey];
    return [placesInSection objectAtIndex:indexPath.row];
}

- (NSString *)topPlaceAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self topPlaceInfoAtIndexPath:indexPath] objectForKey:@"_content"];
}

//- (NSString *)topPlaceAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *sectionKey = [[[self.sectionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section];
//    NSArray *placesInSection = [self.topPlaces objectForKey:sectionKey];
//    return [[placesInSection objectAtIndex:indexPath.row] objectForKey:@"_content"];
//}

- (NSDictionary *)parseLabel:(NSString *)label
{
    NSRange commaRange = [label rangeOfString:@","];
    NSString *title = [label substringToIndex:commaRange.location];
    NSString *subtitle = [label substringFromIndex:commaRange.location + 2];
    return[NSDictionary dictionaryWithObjectsAndKeys:title, @"title", subtitle, @"subtitle", nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacesTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *cellLabel = [self parseLabel:[self topPlaceAtIndexPath:indexPath]];
    
    cell.textLabel.text = [cellLabel objectForKey:@"title"];
    cell.detailTextLabel.text = [cellLabel objectForKey:@"subtitle"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sectionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self.sectionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
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
    
    if (locationPhotosTVC) [locationPhotosTVC release];
    locationPhotosTVC = [[PhotosTableViewController alloc] init];
    
    self.locationPhotosTVC.title = [[self parseLabel:[self topPlaceAtIndexPath:indexPath]] objectForKey:@"title"];
    self.locationPhotosTVC.place = [[self topPlaceInfoAtIndexPath:indexPath] copy];

    //NSLog(@"Location Photos: %@", [FlickrFetcher photosAtPlace:[place objectForKey:@"place_id"]]);
//    if (self.splitViewController) {
//        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.locationPhotosTVC, self.detailViewController, nil];
//    }
    [self.navigationController pushViewController:self.locationPhotosTVC animated:YES];
    
    //[locationPhotosTVC release];
}

- (void)dealloc
{
    [topPlaces release];
    [sectionDictionary release];
    [locationPhotosTVC release];
    [super dealloc];
}

@end
