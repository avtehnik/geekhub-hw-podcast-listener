//
//  GHHEpisode.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/16/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHEpisode.h"
#import "Podcast.h"


@implementation GHHEpisode


-(NSURL*)imageUrl{
    return [NSURL URLWithString:self.image];

    
}
-(NSURL*)audioUrl{
    return [NSURL URLWithString:self.audiofile];
}

-(void)storeWithPodcast:(NSManagedObject*)podcast {
    
    
    GHHAppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    
    
    NSManagedObject *podcastItem =[NSEntityDescription insertNewObjectForEntityForName:@"PodcastItem" inManagedObjectContext:context];
    [podcastItem setValue:self.title forKey:@"name"];
    [podcastItem setValue:self.text forKey:@"text"];
    [podcastItem setValue:@"author" forKey:@"author"];
    [podcastItem setValue:self.image forKey:@"artwork_url"];
    [podcastItem setValue:podcast forKey:@"podcast"];

//    @dynamic name;
//    @dynamic text;
//    @dynamic ;
//    @dynamic author;
//    @dynamic medias;
//    @dynamic podcast;
    
//     [NSNumber numberWithInt:self.podcastId];
//     self.title;
//     self.text;
//     self.image;
//     @"author";
//     [NSNumber numberWithInt:self.playbackIndex]

}

@end
