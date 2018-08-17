//
//  VideoRecordViewController.m
//  TestProject
//
//  Created by fb on 2018/7/23.
//  Copyright © 2018 fb. All rights reserved.
//

#import "VideoRecordViewController.h"
#import "KVVideoRecorder.h"
@interface VideoRecordViewController ()
@property (nonatomic,strong)KVVideoRecorder *recorder;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,strong) UIView *videoView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *recordButton;
@end

@implementation VideoRecordViewController

-(instancetype)initWithVideoName:(NSString*)name{
    self = [super init];
    if (self) {
        _fileName = name;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

-(void)configUI{
    _videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    [self.view addSubview:_videoView];
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    [self.view addSubview:_bottomView];
    [self configVideoView];
    [self configBottomView];
}

-(void)configVideoView{
    self.recorder = [[KVVideoRecorder alloc]initWithPresentView:_videoView];
    //if
    [self.recorder startRecordingWithFileName:_fileName];
    self.recorder.finishedBlock = ^(NSInteger recordedDuration, NSError *error, NSURL *fileURL) {
        //
        NSLog(@"fileurl:%@",fileURL);
    };
}

-(void)configBottomView{
    _recordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 20, 20)];
    _recordButton.backgroundColor = [UIColor redColor];
    [_recordButton addTarget:self action:@selector(stopVideo) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_recordButton];
}

-(void)stopVideo{
    [self.recorder stopCapture];
}

@end
