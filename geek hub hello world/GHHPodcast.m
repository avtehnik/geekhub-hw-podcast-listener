//
//  GHHPodcast.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHPodcast.h"


@implementation GHHPodcast

@synthesize episodes;

-(id)episodeAtIndex:(NSUInteger)index{
    return   [self.episodes objectAtIndex:index];
}


-(NSUInteger)count{
    return self.episodes.count;
}

@end
