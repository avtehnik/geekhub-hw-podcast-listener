//
//  GHHMediaItem.m
//  geek hub hello world
//
//  Created by av_tehnik on 12/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHMediaItem.h"
#import "GHHAppDelegate.h"
#import <CoreData/CoreData.h>
#import "Media.h"

@implementation GHHMediaItem


-(void)storeWithPodcastItem:(PodcastItem*)podcastItem {
    
    
    GHHAppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    
    
    Media *mediaItem =[NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:context];
    mediaItem.url = self.url;
    mediaItem.type = @"audio";
    mediaItem.podcastItem = podcastItem;

//    @dynamic url;
//    @dynamic type;
//    @dynamic playbackPositio;
//    @dynamic podcastItem;
    
}

@end
