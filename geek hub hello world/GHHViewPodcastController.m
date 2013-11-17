//
//  GHHViewPodcastController.m
//  geek hub hello world
//
//  Created by av_tehnik on 10/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewPodcastController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

@interface GHHViewPodcastController(){
    NSTimer *timer;
}

@property(strong,nonatomic) NSArray *eposodes;
@property (weak, nonatomic) IBOutlet UILabel *episodeTitle;
@property (weak, nonatomic) NSURL *audioFile;
@property (weak, nonatomic) IBOutlet UIImageView *episodeImage;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UILabel *episodeTime;


@property (nonatomic, retain) AVPlayer *player;
@property (retain) AVPlayerItem *playerItem;

@end


@implementation GHHViewPodcastController

@synthesize episode;

- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player-bg.png"]];
    self.episodeTitle.text = episode.title;
    self.audioFile = [episode audioUrl];
    self.episodeImage.layer.masksToBounds = YES;
    self.episodeImage.layer.cornerRadius = 10.0;
    [self.episodeImage setImageWithURL:[self.episode imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self play];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)play{
    
    self.player = [[AVPlayer alloc]initWithURL:[self.episode audioUrl]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    [self.player addObserver:self forKeyPath:@"rate" options:0 context:nil];
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    [self.player play];
    
   
    
}

- (IBAction)moveBack:(id)sender {
    
    NSUInteger time = CMTimeGetSeconds(self.player.currentItem.currentTime);
    CMTime newTime = CMTimeMakeWithSeconds(time-15, 600);
    [self.player seekToTime: newTime];
    
}
- (IBAction)pause:(id)sender {
    if ([self.player rate] != 0.0){
        [self.player pause];
    }else{
        [self.player play];
    }
}
- (IBAction)moveToEnd:(id)sender {
    NSUInteger time = CMTimeGetSeconds(self.player.currentItem.currentTime);
    CMTime newTime = CMTimeMakeWithSeconds(time+300, 600);
    [self.player seekToTime: newTime];
}


- (void)timerFireMethod:(NSTimer *)timer{
   
    
    //CMTime *duration = self.player.currentItem.duration; //total time
    //CMTime *currentTime = self.player.currentItem.currentTime;
    
    NSUInteger duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSUInteger time = CMTimeGetSeconds(self.player.currentItem.currentTime);
    
    [self.durationSlider setMaximumValue:duration];
    
    [self.durationSlider setValue:(self.durationSlider.maximumValue - self.durationSlider.minimumValue) * time / duration + 0];
    
    self.episodeTime.text = [NSString stringWithFormat:@"%@ / %@",[self convertTime:time], [self convertTime:duration]];
    
}


-(NSString*)convertTime:(NSUInteger)time{

    NSUInteger dHours = floor(time / 3600);
    NSUInteger dMinutes = floor(time % 3600 / 60);
    NSUInteger dSeconds = floor(time % 3600 % 60);
    
    return [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];

}




- (IBAction)navigate:(id)sender {
    CMTime newTime = CMTimeMakeWithSeconds(self.durationSlider.value, 600);
    [self.player seekToTime: newTime];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}


-(void) viewWillDisappear:(BOOL)animated{
    
    [timer invalidate];
    timer = nil;
    
    [self.player pause];
    [self.player removeObserver:self forKeyPath:@"status"];
    
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    //  code here to play next sound file
    
}


@end
