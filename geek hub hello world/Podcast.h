//
//  Podcast.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/22/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PodcastItem;

@interface Podcast : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * artwork_url;
@property (nonatomic, retain) NSSet *items;
@end

@interface Podcast (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PodcastItem *)value;
- (void)removeItemsObject:(PodcastItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
