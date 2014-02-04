//
//  GHHNetworkModel.h
//  geek hub hello world
//
//  Created by av_tehnik on 11/1/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHHEpisode.h"
#import "GHHPodcast.h"
#import "GHHMediaItem.h"

@interface GHHPodcastModel : NSObject

@property(strong, nonatomic) NSArray *feed;

-(GHHPodcast*)loadFeedWithUrl:(NSString *)url;

@end
