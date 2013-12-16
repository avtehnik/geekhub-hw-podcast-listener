//
//  GHHPodcast.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHPodcast.h"
#import "GHHEpisode.h"
#import "GHHDB.h"

@implementation GHHPodcast

@synthesize episodes;

-(id)episodeAtIndex:(NSUInteger)index{
    return   [self.episodes objectAtIndex:index];
}

-(id)initWithDictionary:(NSDictionary *)data{
    NSLog(@"load init ");
    
    self = [super init];
    if(self)
    {
        self.author = [data objectForKey:@"name"];
        self.name = [data objectForKey:@"name"];
        self.image = [data objectForKey:@"artwork_url"];
        self.url = [data objectForKey:@"name"];
        self.text = [data objectForKey:@"name"];
        self.dbId = [data objectForKey:@"id"];
        [self loadEpisodes];
    }
    return self;
    
}


-(void)loadEpisodes{
    
    NSLog(@"load episodes %ll ",self.dbId);
    
   NSMutableArray *podcasts = [NSMutableArray array];
    
    FMDatabase *db = [GHHDB sharedInstance].contactDB;
    FMResultSet *result = [db executeQuery:@"select * from podcast_item WHERE podcast_id = ?", self.dbId];
    
    while([result next]) {
        
        [podcasts addObject: [[GHHEpisode alloc] initWithNSDictionary:[result resultDictionary]]];
    }

    self.episodes = [NSArray arrayWithArray:podcasts];
    
}

-(NSUInteger)count{
    return self.episodes.count;
}


-(void)store{
    
    FMDatabase *db = [GHHDB sharedInstance].contactDB;
    
    [db executeUpdate:@"INSERT INTO podcast (name, url, artwork_url, description) VALUES(?,?,?,?)",self.name,self.url,self.image,self.text];
    self.dbId = [db lastInsertRowId];
    
    for (GHHEpisode *episode in self.episodes) {
         episode.podcastId = self.dbId;
         [episode store];
    }
    
    NSLog(@"GHHPodcast %long %@ ",self.dbId ,self.name );
    
    NSLog(@"last Error: %@",[db lastErrorMessage]);
}

+(void)deleteWithId:(int)podcastId{
    
    FMDatabase *db = [GHHDB sharedInstance].contactDB;
    
    [db executeUpdate:@"DELETE FROM podcast WHERE id=?",podcastId];
    [db executeUpdate:@"DELETE FROM podcast WHERE id=?",podcastId];

    
}


@end
