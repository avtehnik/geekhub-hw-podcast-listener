//
//  GHHViewController.m
//  geek hub hello world
//
//  Created by av_tehnik on 10/11/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewController.h"
#import "GDataXMLNode.h"
#import "GHHPodcastEpisodeCell.h"
#import "GHHPodcastModel.h"
#import "GHHViewPodcastController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface GHHViewController ()
@property ( strong, nonatomic) IBOutlet UITableView *tableView;
@property BOOL internetActive;
@property BOOL hostActive;
@property ( strong, nonatomic) GDataXMLDocument * doc;
@property ( strong, nonatomic) NSArray *podcasts;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (strong,nonatomic) GHHPodcastModel *model;

@end

@implementation GHHViewController

//@synthesize podcasts;




-(void) viewWillAppear:(BOOL)animated
{
   // self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.hostActive = YES;
}


- (void)viewDidLoad
{
    self.title = @"PodCasts";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
	 self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
	[self.hostReachability startNotifier];
	[self updateInterfaceWithReachability:self.hostReachability];
     self.model = [[GHHPodcastModel alloc] init];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSDictionary *eposode = [self.model episodeAtIndex:indexPath.row];
    cell.subtitle.text = [eposode objectForKey:@"subtitle"];
    cell.title.text = [eposode objectForKey:@"title"];
    [cell.image setImageWithURL:[eposode objectForKey:@"url"] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // NSLog( @"view name %i ", self.podcasts.count);
    return [self.model count];
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


// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
      if(self.hostActive){
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              [self.model loadFeedWithUrl: @"http://laowaicast.rpod.ru/rss.xml"];
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.tableView reloadData];
              });
          });
      }else{
          UIAlertView* alert = [[UIAlertView alloc] init];
          [alert setMessage:@"Без интернета немогу"];
          [alert addButtonWithTitle:@"OK"];
          [alert setCancelButtonIndex:0];
          [alert show];
          
      }
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}



- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    BOOL status = NO;
    if(reachability == self.hostReachability){
        if(netStatus == ReachableViaWWAN || netStatus==ReachableViaWiFi){
            status = YES;
            NSLog(@"yes");
        }else{
            NSLog(@"no");
            status = NO;
        }

    }
    
    if(status != self.hostActive){
        self.hostActive = status;
        UIAlertView* alert = [[UIAlertView alloc] init];
        if(self.hostActive){
            [alert setMessage:@"Интернет появился"];
        }else{
            [alert setMessage:@"Интернет пропал"];
        }
        [alert addButtonWithTitle:@"OK"];
        [alert setCancelButtonIndex:0];
        [alert show];
    }
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    GHHViewPodcastController *player = [segue destinationViewController];

    NSDictionary *episode =  [self.model episodeAtIndex:path.row];
    player.episodeTitle.text = [episode objectForKey:@"title"];
    player.episodeSubtitle.text = [episode objectForKey:@"subtitle"];
    [player.episodeImage setImageWithURL:[episode objectForKey:@"url"] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
