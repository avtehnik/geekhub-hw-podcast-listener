//
//  GHHViewController.m
//  geek hub hello world
//
//  Created by av_tehnik on 10/11/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewEpisodesController.h"
#import "GDataXMLNode.h"
#import "GHHPodcastEpisodeCell.h"
#import "GHHPodcastModel.h"
#import "GHHEpisode.h"
#import "GHHViewPodcastPlayerController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface GHHViewEpisodesController ()<UITableViewDelegate, UITableViewDataSource>
@property ( strong, nonatomic) IBOutlet UITableView *tableView;
@property ( strong, nonatomic) NSArray *episodes;

@end


@implementation GHHViewEpisodesController



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.title = [self.detailItem valueForKey:@"title"];
    self.episodes = [[self.detailItem valueForKeyPath:@"items"] allObjects];
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    if([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)]){
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
 //   self.currentPodcast = [GHHPodcast new];

    	// Do any additional setup after loading the view, typically from a nib.
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.episodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    //here you check for PreCreated cell.
    GHHPodcastEpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSLog(@"cell is nill");
        cell = [[GHHPodcastEpisodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    GHHEpisode *eposode = [self.currentPodcast episodeAtIndex:indexPath.row];
    cell.subtitle.text = [[self.episodes objectAtIndex:indexPath.row] valueForKey:@"text"];
    cell.title.text = [[self.episodes objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell.image setImageWithURL: [[self.episodes objectAtIndex:indexPath.row] valueForKey:@"artwork_url"] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"can edit?");
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}


 

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    
    
//    if ([[segue identifier] isEqualToString:@"GHHViewPodcastControllerSegue"]) {
//        
//        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        GHHViewPodcastPlayerController *pv =  segue.destinationViewController;
//        pv.podcastTitle.text = self.currentPodcast.name;
//        pv.podcast = self.currentPodcast;
//        [pv setEpisodeIndex: path.row];
//        [pv.navigationItem.backBarButtonItem setTitle:@"Your Custom Title"];
//    }
//
    
    if ([[segue identifier] isEqualToString:@"GHHViewPodcastControllerSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
   
}

@end
