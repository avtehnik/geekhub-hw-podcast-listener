//
//  GHHViewPodcastController.h
//  geek hub hello world
//
//  Created by av_tehnik on 10/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHHViewPodcastController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(strong,nonatomic) NSArray *eposodes;

@end
