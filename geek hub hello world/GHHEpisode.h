//
//  GHHEpisode.h
//  geek hub hello world
//
//  Created by av_tehnik on 11/16/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Podcast.h"
#import "GHHAppDelegate.h"
#import <CoreData/CoreData.h>


@interface GHHEpisode : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *audiofile;
@property (copy, nonatomic) NSString *author;
@property (nonatomic) long podcastId;
@property (nonatomic) int playbackIndex;
@property (nonatomic) long dbId;

-(void)storeWithPodcast:(Podcast*)podcast;
-(NSURL*)imageUrl;
-(NSURL*)audioUrl;

@property (strong, nonatomic) id detailItem;
	
@end
