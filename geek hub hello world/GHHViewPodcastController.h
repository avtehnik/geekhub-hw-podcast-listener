//
//  GHHViewPodcastController.h
//  geek hub hello world
//
//  Created by av_tehnik on 10/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHHEpisode.h"


@interface GHHViewPodcastController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *podcastTitle;
@property (strong,nonatomic) GHHEpisode *episode;

@end
