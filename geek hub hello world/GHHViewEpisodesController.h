//
//  GHHViewController.h
//  geek hub hello world
//
//  Created by av_tehnik on 10/11/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHHPodcast.h"



@interface GHHViewEpisodesController : UIViewController< UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,UINavigationBarDelegate,NSFetchedResultsControllerDelegate>
{

}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
