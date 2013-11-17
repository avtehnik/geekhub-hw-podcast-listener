//
//  GHHNetworkModel.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/1/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHPodcastModel.h"
#import "GDataXMLNode.h"

@interface GHHPodcastModel ()

@property ( strong, nonatomic) NSArray *eposodes;

@end

@implementation GHHPodcastModel

-(id)init{
    self = [super init];
    return self;
}


-(GHHPodcast*)loadFeedWithUrl:(NSString *)url{
    
    GHHPodcast *podcast = [[GHHPodcast alloc] init];
    
    NSURL * requestURL = [NSURL URLWithString:url];
    NSURLRequest * request = [NSURLRequest requestWithURL:requestURL];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
 
  
    NSArray *podcastTitle = [doc nodesForXPath:@"//channel/title" error:&error];
    if (podcastTitle.count > 0) {
        GDataXMLElement * xmlTitle = podcastTitle[0];
        podcast.name = xmlTitle.stringValue;
    }
    
    NSArray *podcastImage = [doc nodesForXPath:@"//channel/image/url" error:&error];
    if (podcastImage.count > 0) {
        GDataXMLElement * xmlImage = podcastImage[0];
        podcast.image = xmlImage.stringValue;
    }
    
    NSArray *episodes = [doc nodesForXPath:@"//channel/item" error:&error];
    NSMutableArray *newEpisodes = [[NSMutableArray alloc] init];
    for( GDataXMLElement *episode in episodes){
        GHHEpisode *episodeItem=[[GHHEpisode alloc]init];
        
        NSArray *titles = [episode elementsForName:@"title"];
        if (titles.count > 0) {
            GDataXMLElement * xmlTitle = titles[0];
            episodeItem.title = xmlTitle.stringValue;
        }
        NSArray *descriptions = [episode elementsForName:@"itunes:subtitle"];
        if (descriptions.count > 0) {
            GDataXMLElement * xmlDescription = descriptions[0];
            episodeItem.description = xmlDescription.stringValue;
        }
        
        NSArray *url = [episode elementsForName:@"itunes:image"];
        if (url.count > 0){
            GDataXMLElement * xmlLink = url[0];
            episodeItem.image = [[xmlLink attributeForName:@"href"] stringValue];
        }
        
        NSArray *mp3 = [episode elementsForName:@"enclosure"];
        if (mp3.count > 0){
            GDataXMLElement * xmlLink = mp3[0];
            episodeItem.audiofile = [[xmlLink attributeForName:@"url"] stringValue];
        }
        
        [newEpisodes addObject:episodeItem];
    }
    
    podcast.episodes = [NSArray arrayWithArray:newEpisodes];

    return podcast;
}


@end
