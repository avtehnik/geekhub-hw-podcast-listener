//
//  GHHNetworkModel.h
//  geek hub hello world
//
//  Created by av_tehnik on 11/1/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GHHPodcastModel : NSObject

@property(strong, nonatomic) NSArray *feed;

-(void)loadFeedWithUrl:(NSString *)url;
-(id)episodeAtIndex:(NSUInteger)index;;
-(NSUInteger)count;

@end
