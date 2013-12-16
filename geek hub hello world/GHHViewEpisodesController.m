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
#import "GHHDB.h"


@interface GHHViewEpisodesController ()<UITableViewDelegate, UITableViewDataSource>
@property ( strong, nonatomic) IBOutlet UITableView *tableView;
@property ( strong, nonatomic) GDataXMLDocument * doc;
@property ( strong, nonatomic) NSArray *podcasts;

@end


@implementation GHHViewEpisodesController

@synthesize currentPodcast;




-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"PodCasts";
 
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentPodcast count];
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
    
    GHHEpisode *eposode = [self.currentPodcast episodeAtIndex:indexPath.row];
    cell.subtitle.text = eposode.text;
    cell.title.text = eposode.title;
    [cell.image setImageWithURL:[eposode imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
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
   
    
    
    if ([[segue identifier] isEqualToString:@"GHHViewPodcastControllerSegue"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        GHHViewPodcastPlayerController *pv =  segue.destinationViewController;
        pv.podcastTitle.text = self.currentPodcast.name;
        pv.podcast = self.currentPodcast;
        [pv setEpisodeIndex: path.row];
        [pv.navigationItem.backBarButtonItem setTitle:@"Your Custom Title"];
    }

   
}

@end
