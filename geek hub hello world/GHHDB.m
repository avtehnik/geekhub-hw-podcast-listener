//
//  GHHDB.m
//  geek hub hello world
//
//  Created by av_tehnik on 12/10/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHDB.h"

@interface GHHDB()

@property (strong, nonatomic) NSString *databasePath;

@end


@implementation GHHDB




-(id)init{
    self = [super init];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseTargetPath = [path stringByAppendingPathComponent:@"Player.sqlite"];
    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databaseTargetPath ] == YES){
          self.contactDB = [FMDatabase databaseWithPath: databaseTargetPath] ;
        [ self.contactDB open];
    }
    
    return self;
}



#pragma mark - singleton method

+ (GHHDB*)sharedInstance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    //static id sharedObject = nil;  //if you're not using ARC
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        //sharedObject = [[[self alloc] init] retain]; // if you're not using ARC
    });
    return sharedObject;
}

+(void)initDB{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseTargetPath = [path stringByAppendingPathComponent:@"Player.sqlite"];
    NSString *databadeFromRes = [[NSBundle mainBundle] pathForResource:@"Player" ofType:@"sqlite"];
    
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:databaseTargetPath];
    if(!isFileExists){
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:databadeFromRes toPath:databaseTargetPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+(void)close{
    
  [[GHHDB sharedInstance].contactDB close];
    
}



@end
