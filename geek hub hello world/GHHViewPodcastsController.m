//
//  GHHViewPodcastsController.m
//  geek hub hello world
//
//  Created by av_tehnik on 12/14/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewPodcastsController.h"
#import "GHHViewEpisodesController.h"
#import "GHHDB.h"


@interface GHHViewPodcastsController ()

@property (strong,nonatomic) NSMutableArray *podcasts;

@end

@implementation GHHViewPodcastsController

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

    [self.tableView setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.podcasts = [NSMutableArray array];
    
    FMDatabase *db = [GHHDB sharedInstance].contactDB;
    FMResultSet *result = [db executeQuery:@"select * from podcast"];
    
    while([result next]) {
        [self.podcasts addObject:[result resultDictionary]];
    }
    
    [self.tableView reloadData];
    NSLog(@"viewWillAppear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"podcasts count %i",[self.podcasts count]);
    return [self.podcasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"podcastitem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *podcast = [self.podcasts objectAtIndex:indexPath.row];
    cell.textLabel.text = [podcast objectForKey:@"name"];
    return cell;
}

- (IBAction)edit:(id)sender {
    self.tableView.editing = !self.tableView.editing;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"edit");

    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"podcastView"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        GHHViewEpisodesController *episodesController =  segue.destinationViewController;
        episodesController.currentPodcast = [[GHHPodcast alloc] initWithDictionary:[self.podcasts objectAtIndex:path.row]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    NSDictionary *podcast = [self.podcasts objectAtIndex:indexPath.row];

    NSLog(@"delete with id %@",[podcast objectForKey:@"id"]);
    
 
  
    
    [GHHPodcast deleteWithId:[podcast objectForKey:@"id"]];
    
    [self.podcasts removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"select");
}
@end
