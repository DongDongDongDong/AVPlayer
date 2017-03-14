//
//  AVPlayer.m
//  AVPlayer
//
//  Created by wei on 2017/3/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "SXAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SXAVPlayer ()
@property(nonatomic,strong) AVPlayer *player;
@property (nonatomic ,weak) NSURL *url;


@end

@implementation SXAVPlayer

static SXAVPlayer *instance;
+ (instancetype)shareInstance{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc] init];
        });
        
    }
    return instance;
}

- (NSTimeInterval)duration{
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(totalTime)) {
        return 0.0;
    }
    return totalTime;
}

- (NSTimeInterval)currentTime{
    NSTimeInterval currentT = CMTimeGetSeconds(self.player.currentItem.currentTime);
    if (isnan(currentT)) {
        return 0.0;
    }
    return currentT;
}

- (CGFloat)progress{
    if (self.duration == 0.0) {
        return 0.0;
    }
    return self.currentTime / self.duration;
}

- (CGFloat)loadprogress{
    if (self.duration == 0.0) {
        return 0.0;
    }
    CMTimeRange range = [self.player.currentItem.loadedTimeRanges.lastObject CMTimeRangeValue];
    CMTime loadTime = CMTimeAdd(range.start, range.duration);
    NSTimeInterval loadtimeSec = CMTimeGetSeconds(loadTime);
    return (loadtimeSec / self.duration);
}


- (void)playWithUrl:(NSURL *)url{
    
    if ([self.url isEqual:url]) {
        if (self.state == SXAudioPlayerStateLoading) {
            return;
        }
        if (self.state == SXAudioPlayerStatePlaying) {
            return;
        }
        if (self.state == SXAudioPlayerStateStoped) {
            return;
        }
        if (self.state == SXAudioPlayerStatePause) {
            [self resume];
            return;
        }
        return;
    }
    
    
    self.url = url;
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    if (self.player.currentItem) {
        [self clearObserver];
    }
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:item];
    

}

- (void)stop{
    [self.player pause];
    [self clearObserver];
    self.player = nil;
    self.state = SXAudioPlayerStateStoped;
}

- (void)pause{
    [self.player pause];
    self.state = SXAudioPlayerStatePause;


}

- (void)resume{
    [self.player play];
    self.state = SXAudioPlayerStatePlaying;
}

- (void)seekWithTimeInterval:(NSTimeInterval)timeInterval {
    
    
    
    
    //    CMTime 影片时间
    // 影片时间-> 秒
    //CMTimeGetSeconds(<#CMTime time#>);
    // 秒 -> 影片时间
    //CMTimeMake(秒, NSEC_PER_SEC)
    
    // 1. 获取当前播放时间 + 15
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.currentTime) + timeInterval;
    
    [self.player seekToTime:CMTimeMake(sec, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间段的资源");
        }else {
            NSLog(@"取消加载这个时间段的资源");
        }
    }];
    
}

- (void)kuaijin: (NSTimeInterval) timeInterval{
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.currentTime) + timeInterval;
    [self.player seekToTime:CMTimeMake(sec, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间段的资源");
        }else {
            NSLog(@"取消加载这个时间段的资源");
        }
    }];
}

- (void)doubleRate{
    self.player.rate = 2 * self.player.rate;
}

- (void)mute{
    self.player.muted = !self.player.muted;
}

- (void)seekToProgress:(float)progress{
    NSTimeInterval timeInterval = CMTimeGetSeconds(self.player.currentItem.duration) * progress;
    [self.player seekToTime:CMTimeMakeWithSeconds(timeInterval, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间段的资源");
        }else {
            NSLog(@"取消加载这个时间段的资源");
        }
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]){
        AVPlayerItemStatus status =  [change[NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"资源无效");
                self.state = SXAudioPlayerStateFailed;

                break;
            }
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"资源准备好了, 已经可以播放");
                [self.player play];
                self.state = SXAudioPlayerStatePlaying;
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"资源加载失败");
                self.state = SXAudioPlayerStateFailed;
                break;
            }
                
            default:
                break;
        }
        
    }
}

- (void) clearObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}
@end
