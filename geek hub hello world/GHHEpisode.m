//
//  GHHEpisode.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/16/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHEpisode.h"
#import "GHHDB.h"
#import "FMDatabase.h"

@implementation GHHEpisode


-(NSURL*)imageUrl{
    return [NSURL URLWithString:self.image];

    
}
-(NSURL*)audioUrl{
    return [NSURL URLWithString:self.audiofile];
}

-(void)store{
    FMDatabase *db = [GHHDB sharedInstance].contactDB;
    
//    self.title = @"title";
//    self.text = @"text";
//    self.image = @"image";
//    self.playbackIndex  = 10;
    
   // NSLog(@"%d , %@, %@, %@, %@, %d",self.podcastId, self.title, self.text, self.image,@"author",self.playbackIndex);
    
    [db executeUpdate:@"INSERT INTO podcast_item (podcast_id, name, description, artwork_url, author,current_media_index) VALUES(?,?,?,?,?,?)",
     [NSNumber numberWithInt:self.podcastId], self.title, self.text, self.image,@"author",[NSNumber numberWithInt:self.playbackIndex]];
   
    self.dbId = [db lastInsertRowId];

    
//    NSLog(@"GHHEpisode %i ",self.dbId);

}


-(id)initWithNSDictionary:(NSDictionary *)data{
    self = [super init];
    if(self)
    {
        self.dbId = [data objectForKey:@"id"];
        self.title = [data objectForKey:@"name"];
        self.text  = [data objectForKey:@"description"];
        self.image  = [data objectForKey:@"artwork_url"];
        self.playbackIndex = [data objectForKey:@"current_media_index"];
    }
    return self;
    
}


@end
