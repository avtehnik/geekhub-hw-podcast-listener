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


-(void)loadFeedWithUrl:(NSString *)url{
    
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
 
    
    NSArray *episodes = [doc nodesForXPath:@"//channel/item" error:&error];
    NSMutableArray *newEpisodes = [[NSMutableArray alloc] init];
    for( GDataXMLElement *episode in episodes){
        NSMutableDictionary *newEpisode=[[NSMutableDictionary alloc]init];
        
        NSArray *titles = [episode elementsForName:@"title"];
        if (titles.count > 0) {
            GDataXMLElement * title = titles[0];
            [newEpisode setObject:title.stringValue forKey:@"title"];
        }
        NSArray *descriptions = [episode elementsForName:@"itunes:subtitle"];
        if (descriptions.count > 0) {
            GDataXMLElement * description = descriptions[0];
            [newEpisode setObject:description.stringValue forKey:@"subtitle"];
            // cell.subtitle.text = description.stringValue;
        }
        
        NSArray *url = [episode elementsForName:@"itunes:image"];
        if (url.count > 0){
            GDataXMLElement * link = url[0];
            [newEpisode setObject:[NSURL URLWithString:[[link attributeForName:@"href"] stringValue]] forKey:@"url"];
        }
        
        
        [newEpisodes addObject:[NSDictionary dictionaryWithDictionary:newEpisode]];
    }
    
    self.eposodes = [NSArray arrayWithArray:newEpisodes];
    
}


-(id)episodeAtIndex:(NSUInteger)index{
    return [self.eposodes objectAtIndex:index];
}


-(NSUInteger)count{
    return self.eposodes.count;
}




@end
