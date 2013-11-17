//
//  GHHEpisode.h
//  geek hub hello world
//
//  Created by av_tehnik on 11/16/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHHEpisode : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *audiofile;

-(NSURL*)imageUrl;
-(NSURL*)audioUrl;

@end
