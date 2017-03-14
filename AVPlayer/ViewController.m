//
//  ViewController.m
//  AVPlayer
//
//  Created by wei on 2017/3/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "ViewController.h"
#import "SXAVPlayer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currenttimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *preDownloadProgress;
@property (weak, nonatomic) IBOutlet UISlider *playProgress;
@property (strong, nonatomic)     NSTimer *timer ;
@end

@implementation ViewController
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timer];
}

- (void)update{
    self.playProgress.value = [SXAVPlayer shareInstance].progress;
    self.preDownloadProgress.value = [SXAVPlayer shareInstance].loadprogress;
    self.currenttimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(int)[SXAVPlayer shareInstance].currentTime / 60,(int)[SXAVPlayer shareInstance].currentTime % 60];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(int)[SXAVPlayer shareInstance].duration / 60,(int)[SXAVPlayer shareInstance].duration % 60];}

- (IBAction)play:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://audio.xmcdn.com/group23/M06/5C/70/wKgJL1g0DVahoMhrAMJMkvfN17c025.m4a"];

    SXAVPlayer *player = [SXAVPlayer shareInstance];
    [player playWithUrl:url];
}

- (IBAction)pause:(id)sender {
    [[SXAVPlayer shareInstance] pause];
}

- (IBAction)stop:(id)sender {
    [[SXAVPlayer shareInstance] stop];

}

- (IBAction)resume:(id)sender {
    [[SXAVPlayer shareInstance] resume];
}

- (IBAction)kuaijin:(id)sender {
    [[SXAVPlayer shareInstance] seekWithTimeInterval:15];
    
}
- (IBAction)doubleRate:(id)sender {
      [[SXAVPlayer shareInstance] doubleRate];
}
- (IBAction)mute:(id)sender {
      [[SXAVPlayer shareInstance] mute];
}
- (IBAction)progressValue:(UISlider *)sender {
      [[SXAVPlayer shareInstance] seekToProgress:sender.value];
}

@end
