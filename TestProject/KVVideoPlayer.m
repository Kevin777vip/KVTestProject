//
//  KVVideoPlayer.m
//  TestProject
//
//  Created by fb on 2018/8/27.
//  Copyright © 2018 fb. All rights reserved.
//

#import "KVVideoPlayer.h"
@interface KVVideoPlayer()
@property (nonatomic,strong) UIView *playerView;
@end
@implementation KVVideoPlayer
-(instancetype)initWithView:(UIView*)playerView{
    if (self = [super init]) {
        self.playerView = playerView;
        [self configPlayer];
    }
    return self;
}

-(void)configPlayer{
    _playerController = [[AVPlayerViewController alloc]init];
    _playerController.view.frame = CGRectMake(0, 0, _playerView.frame.size.width, _playerView.frame.size.height);
    _playerController.showsPlaybackControls = YES;
    _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    NSURL *url = [NSURL URLWithString:@"http://172.17.1.139:8181/download/appServerImage/file/faceSign/445281198606095334_1234567.mp4"];
    _playerController.player = [AVPlayer playerWithURL:url];
    [self.playerView addSubview:_playerController.view];
//    [self setVideoWithUrl:nil];
}

-(void)setVideoWithUrl:(NSURL*)url{
//    url = [NSURL URLWithString:@"http://172.17.1.139:8181/download/appServerImage/file/faceSign/445281198606095334_1234567.mp4"];
//    url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    url = [NSURL URLWithString:@"http://172.17.1.243:8181/download/ns/file/opm.mp4"];
    _playerController.player = [AVPlayer playerWithURL:url];
}

-(void)startVideo{
    [_playerController.player play];
}

-(void)pauseVideo{
    [_playerController.player pause];
}
@end
