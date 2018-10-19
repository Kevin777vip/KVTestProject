//
//  VideoRecordViewController.m
//  TestProject
//
//  Created by fb on 2018/7/23.
//  Copyright © 2018 fb. All rights reserved.
//

#import "VideoRecordViewController.h"
#import "KVVideoRecorder.h"
@import AVFoundation;
@interface VideoRecordViewController ()
@property (nonatomic,strong)KVVideoRecorder *recorder;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,strong) UIView *videoView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *recordButton;
@property(nonatomic,strong) AVSpeechSynthesizer *voice;
@property(nonatomic,strong) NSArray *stepContent;
@property(nonatomic,strong) UITextField *textField;
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
    [self configData];
    [self configUI];
}

-(void)configData{
    _stepContent = [[NSArray alloc]initWithObjects:@"第一步，打开冰箱",@"第二部，把大象放进去",@"第三部，关上冰箱", nil];
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
    _recordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, 200, 20)];
    _recordButton.backgroundColor = [UIColor redColor];
    [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_recordButton setTitle:@"开始" forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(stopVideo) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_recordButton];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    _textField.backgroundColor = [UIColor grayColor];
    [_bottomView addSubview:_textField];
}

-(void)stopVideo{
//    [self.recorder stopCapture];
    [self startVoice];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.recorder stopCapture];
    });
}

-(void)startVoice{
    _voice = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *speech = [[AVSpeechUtterance alloc]initWithString:@"请大声听我朗读，一二三四五六七，上山打老虎"];
    speech.volume = 1;
    speech.rate = 0.5;
    speech.pitchMultiplier = 1;
    
    AVSpeechSynthesisVoice *lauguage = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//zh-CN  en-us
    speech.voice = lauguage;
    
    [_voice speakUtterance:speech];
}

@end
