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
@property (strong, nonatomic) GHHEpisode *episode;


@property (nonatomic, retain) AVPlayer *player;
@property (retain) AVPlayerItem *playerItem;

@end


@implementation GHHViewPodcastController
@synthesize episodeIndex;

- (void)viewDidLoad
{
    
    NSLog(@"prapare %@ ", self);


    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player-bg.png"]];
    
    self.episode =  [self.podcast episodeAtIndex:self.episodeIndex];
    NSLog(@"episode %i",self.episodeIndex);
    [self applayEpisode];
    [self playEpisode];
    
    [self.durationSlider setThumbImage:[UIImage imageNamed:@"player-control-progres.png"] forState:UIControlStateNormal];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



-(void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent){
        NSLog(@"episode pause");
        [self.player pause];
    }
}

- (void)applayEpisode{
    self.episodeTitle.text = self.episode.title;
    self.audioFile = [self.episode audioUrl];
    self.episodeImage.layer.masksToBounds = YES;
    self.episodeImage.layer.cornerRadius = 10.0;
    [self.episodeImage setImageWithURL:[self.episode imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextEpisode:(id)sender {
    [self playNextEpisode];
}

- (void)playNextEpisode{
    self.episodeIndex++;
    if(self.podcast.count>=self.episodeIndex){
        self.episode =  [self.podcast episodeAtIndex:self.episodeIndex];
        [self applayEpisode];
        [self playEpisode];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)playEpisode{
    
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
    if(time>17){
        CMTime newTime = CMTimeMakeWithSeconds(time-15, 600);
        [self.player seekToTime: newTime];
    }else{
        CMTime newTime = CMTimeMakeWithSeconds(0, 600);
        [self.player seekToTime: newTime];
    }
    
}
- (IBAction)pause:(id)sender {
    if ([self.player rate] != 0.0){
        [self.player pause];
    }else{
        [self.player play];
    }
}


- (void)timerFireMethod:(NSTimer *)timer{
    
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
    [self playNextEpisode];
}


@end
