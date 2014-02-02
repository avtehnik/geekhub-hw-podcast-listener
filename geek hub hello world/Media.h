//
//  Media.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/22/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PodcastItem;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * playbackPositio;
@property (nonatomic, retain) PodcastItem *podcastItem;

@end
