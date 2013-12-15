//
//  GHHViewPodcastController.m
//  geek hub hello world
//
//  Created by av_tehnik on 10/17/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewPodcastPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

@interface GHHViewPodcastPlayerController(){
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


@implementation GHHViewPodcastPlayerController
@synthesize episodeIndex;

- (void)viewDidLoad
{
    
    NSLog(@"prapare episode %i ", self.episodeIndex);
    
    //self.navigationController.navigationBar.topItem.title = @"Back";

    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 21)];
    UIImage *bgimage = [UIImage imageNamed:@"palyer-back-btn"];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setBackgroundImage:bgimage forState:UIControlStateNormal];
 //    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backToEpisodesList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player-bg.png"]];
    
    self.navigationController.navigationBar.tintColor = [self getUIColorObjectFromHexString:@"#222429" alpha:1];
    
    
    UIImage *backgroundImage = [self drawImageWithColor:[self getUIColorObjectFromHexString:@"#222429" alpha:1]];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    
    self.episode =  [self.podcast episodeAtIndex:self.episodeIndex];
    NSLog(@"episode %i",self.episodeIndex);
    [self applayEpisode];
    [self playEpisode];
    
    [self.durationSlider setThumbImage:[UIImage imageNamed:@"player-control-progres"] forState:UIControlStateNormal];
    [self.durationSlider setMinimumTrackImage:[UIImage imageNamed:@"player-control-slider-progress-left"] forState:UIControlStateNormal];
    [self.durationSlider setMaximumTrackImage:[UIImage imageNamed:@"player-control-slider-progress-rigth"] forState:UIControlStateNormal];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) backToEpisodesList{
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UIImage*)drawImageWithColor:(UIColor*)color{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath;
    imagePath = [[paths lastObject] stringByAppendingPathComponent:@"NavImage.png"];
    if([fileManager fileExistsAtPath:imagePath]){
        return  [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    UIGraphicsBeginImageContext(CGSizeMake(320, 40));
    [color setFill];
    UIRectFill(CGRectMake(0, 0, 320, 40));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:imagePath atomically:YES];
    return image;
}


- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}


-(void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent){
        NSLog(@"episode pause");
        [self.player pause];
    }
}

- (void)applayEpisode{
    self.episodeTitle.text = self.episode.title;
    NSLog(@"title %@", self.episodeTitle.text );
    self.audioFile = [self.episode audioUrl];
    self.episodeImage.layer.masksToBounds = YES;
    self.episodeImage.layer.cornerRadius = 3.0;
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
        [self backToEpisodesList];
    }
}


-(BOOL)isPlaying{

    return [self.player rate] != 0.0;

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
    if ([self isPlaying]){
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
    if (![self isPlaying]){
        [self.player play];
    }
    
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
