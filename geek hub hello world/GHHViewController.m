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

//@synthesize podcasts;




-(void) viewWillAppear:(BOOL)animated
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.hostActive = YES;
}


- (void)viewDidLoad
{
    self.title = @"PodCasts";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
	self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
	[self.hostReachability startNotifier];
	[self updateInterfaceWithReachability:self.hostReachability];
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
    
    GDataXMLElement *item = _podcasts[indexPath.row];
    NSArray *titles = [item elementsForName:@"title"];
    if (titles.count > 0) {
        GDataXMLElement * title = titles[0];
        cell.title.text = title.stringValue;
    }
    NSArray *descriptions = [item elementsForName:@"itunes:subtitle"];
    if (descriptions.count > 0) {
        GDataXMLElement * description = descriptions[0];
        cell.subtitle.text = description.stringValue;
    }
    
    NSArray *url = [item elementsForName:@"itunes:image"];
    if (url.count > 0) {
        GDataXMLElement * link = url[0];
        [cell.image setImageWithURL:[NSURL URLWithString:[[link attributeForName:@"href"] stringValue]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
    }
    
    
    return cell;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   // NSLog( @"view name %i ", self.podcasts.count);
    return _podcasts.count;
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
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    UIViewController *DVC = [segue destinationViewController];
    
    GDataXMLElement *item = _podcasts[path.row];
    NSArray *titles = [item elementsForName:@"title"];
    if (titles.count > 0) {
        GDataXMLElement * title = titles[0];
        DVC.title = title.stringValue;
    }
    
}


// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self parcePodcastForUrl:textField.text];
    [self.tableView reloadData];
    
}

-(void)parcePodcastForUrl:(NSString *)url{

    if(self.hostActive){
        
        NSURL * requestURL = [NSURL URLWithString:url];
        NSURLRequest * request = [NSURLRequest requestWithURL:requestURL];
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        
        self.doc = [[GDataXMLDocument alloc] initWithData:responseData
                                                  options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        NSArray * nodes = [self.doc nodesForXPath:@"//channel/item" error:&error];
        _podcasts = nodes;
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



-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
