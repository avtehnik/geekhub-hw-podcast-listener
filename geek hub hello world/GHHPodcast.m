//
//  GHHPodcast.m
//  geek hub hello world
//
//  Created by av_tehnik on 11/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHPodcast.h"
#import "GHHEpisode.h"
#import "GHHAppDelegate.h"
#import <CoreData/CoreData.h>
//#import "Podcast.h"

@implementation GHHPodcast

@synthesize episodes;

-(void)store{
    
    
    GHHAppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSLog(@"store %@ context %@", self.name, context);
    
    
     NSManagedObject *podcast =[NSEntityDescription insertNewObjectForEntityForName:@"Podcast" inManagedObjectContext:context];
    [podcast setValue:self.name forKey:@"title"];
    [podcast setValue:self.text forKey:@"subtitle"];
    [podcast setValue:@"author" forKey:@"author"];
   // [managedObject setSubtitle:self.name];
   // [managedObject setArtwork_url:self.url];
    
    
    
    for (GHHEpisode *episode in self.episodes) {
        [episode storeWithPodcast:podcast];
    }
    
    NSError *error;
    if(![context save:&error]){
        NSLog(@"not stored %@",error);
        
	    //This is a serious error saying the record
	    //could not be saved. Advise the user to
	    //try again or restart the application.
    }
    
    
    
}

 
@end
