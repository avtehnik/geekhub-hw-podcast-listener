//
//  GHHViewPodcastsController.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/14/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHHViewPodcastsController : UITableViewController< UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,UINavigationBarDelegate,NSFetchedResultsControllerDelegate>{


}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
