//
//  PodcastItem.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/22/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Podcast.h"

@interface PodcastItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * artwork_url;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSSet *medias;
@property (nonatomic, retain) Podcast *podcast;
@end

@interface PodcastItem (CoreDataGeneratedAccessors)

- (void)addMediasObject:(NSManagedObject *)value;
- (void)removeMediasObject:(NSManagedObject *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

@end
