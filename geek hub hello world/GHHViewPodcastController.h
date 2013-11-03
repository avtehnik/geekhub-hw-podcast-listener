//
//  GHHViewPodcastController.h
//  geek hub hello world
//
//  Created by av_tehnik on 10/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHHViewPodcastController : UIViewController

@property(strong,nonatomic) NSArray *eposodes;
@property (weak, nonatomic) IBOutlet UILabel *eposodeTitle;
@property (weak, nonatomic) IBOutlet UITextView *eposodeTsubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *eposodeTimage;

@end
