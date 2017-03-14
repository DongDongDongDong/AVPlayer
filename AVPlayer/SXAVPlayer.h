//
//  AVPlayer.h
//  AVPlayer
//
//  Created by wei on 2017/3/13.
//  Copyright © 2017年 wei. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SXAudioPlayerState) {
    SXAudioPlayerStateUnknown,
    SXAudioPlayerStateLoading,
    SXAudioPlayerStatePlaying,
    SXAudioPlayerStateStoped,
    SXAudioPlayerStatePause,
    SXAudioPlayerStateFailed
};

@interface SXAVPlayer : NSObject
@property (nonatomic,assign,readonly) NSTimeInterval duration;
@property (nonatomic,assign,readonly) NSTimeInterval currentTime;

@property (nonatomic,assign,readonly) CGFloat progress;
@property (nonatomic,assign,readonly) CGFloat loadprogress;

@property (nonatomic,assign) SXAudioPlayerState state;


+ (instancetype)shareInstance;

- (void)playWithUrl:(NSURL *)url;

- (void)stop;

- (void)pause;

- (void)resume;

- (void)seekWithTimeInterval:(NSTimeInterval)timeInterval;

- (void)kuaijin: (NSTimeInterval) timeInterval;

- (void)doubleRate;

- (void)mute;

- (void)seekToProgress:(float)progress;


@end
