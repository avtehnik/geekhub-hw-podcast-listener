//
//  GHHMediaItem.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PodcastItem.h"

@interface GHHMediaItem : NSObject
@property (copy,nonatomic) NSString *url;
@property (copy,nonatomic) NSString *type;
@property (copy,nonatomic) NSString *text;
-(void)storeWithPodcastItem:(PodcastItem*)podcastItem;

@end
