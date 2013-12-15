//
//  GHHDB.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/10/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>


@interface GHHDB : NSObject
+ (void)initDB;
+(void)close;
+ (GHHDB*)sharedInstance;
@property (strong, nonatomic) FMDatabase *contactDB;

@end
