//
//  GHHPodcast.h
//  geek hub hello world
//
//  Created by av_tehnik on 11/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GHHPodcast : NSObject

@property (strong,nonatomic) NSArray *episodes;
@property (copy,nonatomic) NSString *author;

@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *image;
@property (copy,nonatomic) NSString *url;
@property (copy,nonatomic) NSString *text;
@property (nonatomic) long dbId;
-(void)store;
@end
