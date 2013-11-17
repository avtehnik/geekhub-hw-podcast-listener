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
#import "GHHEpisode.h"
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

@end


@implementation GHHViewController

@synthesize currentPodcast;




-(void) viewWillAppear:(BOOL)animated
{
   // self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.hostActive = YES;
}

-(void) viewDidAppear:(BOOL)animated{
    [self processUrl:@"http://laowaicast.rpod.ru/rss.xml"];

}


- (void)viewDidLoad
{
    self.title = @"PodCasts";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
	 self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
	[self.hostReachability startNotifier];
	[self updateInterfaceWithReachability:self.hostReachability];
 
    if([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)]){
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    self.currentPodcast = [GHHPodcast new];
    
//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
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
    
    GHHEpisode *eposode = [self.currentPodcast episodeAtIndex:indexPath.row];
    cell.subtitle.text = eposode.description;
    cell.title.text = eposode.title;
    [cell.image setImageWithURL:[eposode imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // NSLog( @"view name %i ", self.podcasts.count);
    return [self.currentPodcast count];
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


-(void)processUrl:(NSString *)url{
    if(self.hostActive){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GHHPodcastModel *model = [[GHHPodcastModel alloc] init];
            self.currentPodcast = [model loadFeedWithUrl: url];
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


// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self processUrl:textField.text];
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
    
    
    NSLog(@"prapare");
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    GHHViewPodcastController *pv = [[GHHViewPodcastController alloc] init];
    
    pv = [segue destinationViewController];
    GHHEpisode *episode =  [self.currentPodcast episodeAtIndex:path.row];
    pv.podcastTitle.text = self.currentPodcast.name;
    pv.episode = episode;
    UIView * view = pv.view;

}


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
