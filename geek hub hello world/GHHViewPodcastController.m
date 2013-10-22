//
//  GHHViewPodcastController.m
//  geek hub hello world
//
//  Created by av_tehnik on 10/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewPodcastController.h"

@interface GHHViewPodcastController ()


@end


@implementation GHHViewPodcastController
@synthesize eposodes;

- (void)viewDidLoad
{
    
    NSLog(@"hello");
    
    eposodes = [[NSArray alloc]initWithObjects:@"Episode 1",@"Episode 2",@"Episode 3",@"Episode 4",@"Episode 5", nil ];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"podcast";
    //here you check for PreCreated cell.
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ episode %i", self.navigationItem.title , (indexPath.row+1)];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@" request ");

    return 10;
}

@end
