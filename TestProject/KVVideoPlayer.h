//
//  KVVideoPlayer.h
//  TestProject
//
//  Created by fb on 2018/8/27.
//  Copyright © 2018 fb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import AVKit;
@interface KVVideoPlayer : NSObject
@property (nonatomic,strong) AVPlayerViewController *playerController;
-(instancetype)initWithView:(UIView*)playerView;
-(void)setVideoWithUrl:(NSURL*)url;
@end
