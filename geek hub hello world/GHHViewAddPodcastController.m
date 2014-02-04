//
//  GHHViewAddPodcastController.m
//  geek hub hello world
//
//  Created by av_tehnik on 12/15/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewAddPodcastController.h"
#import "GDataXMLNode.h"
#import "GHHPodcastEpisodeCell.h"
#import "GHHPodcastModel.h"
#import "GHHEpisode.h"
#import "GHHViewPodcastPlayerController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface GHHViewAddPodcastController ()
@property BOOL internetActive;
@property BOOL hostActive;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@end

@implementation GHHViewAddPodcastController{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)closeView:(id)sender {
    
    NSLog(@"close ");
    //[self processUrl:@"http://laowaicast.rpod.ru/rss.xml"];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)addPodcast:(id)sender {
    NSLog(@"addPodcast");

    [self processUrl:@"http://laowaicast.rpod.ru/rss.xml"];
    
}

- (void)viewDidLoad
{
    
    self.hostActive = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
	[self.hostReachability startNotifier];
    //	[self updateInterfaceWithReachability:self.hostReachability];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)processUrl:(NSString *)url{
    if(self.hostActive){
        
        NSLog(@"start");
        [[[GHHPodcastModel alloc] init] loadFeedWithUrl: url];
        NSLog(@"end");
        [self dismissViewControllerAnimated:true completion:nil];

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

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


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
