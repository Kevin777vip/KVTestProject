//
//  KVVideoPlayerView.m
//  TestProject
//
//  Created by fb on 2018/8/27.
//  Copyright © 2018 fb. All rights reserved.
//

#import "KVVideoPlayerView.h"
@import AVKit;
@interface KVVideoPlayerView()
@property (nonatomic,strong) AVPlayerViewController *playerController;
@end
@implementation KVVideoPlayerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configPlayer];
    }
    return self;
}

-(void)configPlayer{
    _playerController = [[AVPlayerViewController alloc]init];
    _playerController.view.frame = self.bounds;
    _playerController.showsPlaybackControls = YES;
    [self addSubview:_playerController.view];    
    [self setVideoWithUrl:nil];
}

-(void)configUI{
    
}

-(void)setVideoWithUrl:(NSURL*)url{
    url = [NSURL URLWithString:@"http://172.17.1.139:8181/download/appServerImage/file/faceSign/445281198606095334_1234567.mp4"];
    _playerController.player = [AVPlayer playerWithURL:url];
    [_playerController.player play];
}

-(void)startVideo{
    [_playerController.player play];
}

-(void)pauseVideo{
    [_playerController.player pause];
}



@end
