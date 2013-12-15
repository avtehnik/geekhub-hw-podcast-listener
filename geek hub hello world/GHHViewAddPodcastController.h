//
//  GHHViewAddPodcastController.h
//  geek hub hello world
//
//  Created by av_tehnik on 12/15/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface GHHViewAddPodcastController : UIViewController< UITextFieldDelegate>{
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@end
