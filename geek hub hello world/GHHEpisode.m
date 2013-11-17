//
//  GHHEpisode.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/16/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHEpisode.h"

@implementation GHHEpisode


-(NSURL*)imageUrl{
    return [NSURL URLWithString:self.image];

    
}
-(NSURL*)audioUrl{
    return [NSURL URLWithString:self.audiofile];
}



@end
