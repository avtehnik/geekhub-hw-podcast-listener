//
//  GHHEpisode.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/16/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHEpisode.h"


@implementation GHHEpisode


-(void)storeWithPodcast:(Podcast*)podcast {
    
    
    GHHAppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    
    
    PodcastItem *podcastItem =[NSEntityDescription insertNewObjectForEntityForName:@"PodcastItem" inManagedObjectContext:context];
    podcastItem.name  = self.title;
    podcastItem.text = self.text;
    podcastItem.author = @"author";
    podcastItem.artwork_url = self.image;
    podcastItem.podcast = podcast;

    for (GHHMediaItem *media in self.medias) {
        [media storeWithPodcastItem:podcastItem];
    }
    
//    @dynamic name;
//    @dynamic text;
//    @dynamic ;
//    @dynamic author;
//    @dynamic medias;
//    @dynamic podcast;

}

@end
