//
//  VoiceRecognizeViewController.m
//  TestProject
//
//  Created by fb on 2018/10/19.
//  Copyright © 2018 fb. All rights reserved.
//

#import "VoiceRecognizeViewController.h"
#import <ReactiveObjC.h>
@import Speech;
@import AVFoundation;
@interface VoiceRecognizeViewController ()<SFSpeechRecognizerDelegate>
@property (nonatomic,strong) SFSpeechRecognizer *recognizer;
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recongizerRequest;
@property (nonatomic,strong) SFSpeechRecognitionTask *recongitionTask;
@property (nonatomic,strong) AVAudioEngine *audioEngine;

@property (nonatomic,strong) UILabel *speechLabel;
@property (nonatomic,strong) UIButton *startButton;
@property (nonatomic,strong) UIButton *stopButton;
@end

@implementation VoiceRecognizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestAuthorization];
    [self configUI];
}

- (void)requestAuthorization{
    @weakify(self);
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        NSLog(@"status:%ld",(long)status);
        @strongify(self);
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            [self configSpeechRecognizer];
        }
    }];
}

- (void)configUI{
    _speechLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 300, 40)];
    _speechLabel.textColor = [UIColor blackColor];
    _speechLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_speechLabel];
    
    _startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, 80, 30)];
    _startButton.backgroundColor = [UIColor redColor];
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    @weakify(self);
    [[self.startButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (x) {
            [self startVoiceRecord];
        }
    }];
    [self.view addSubview:_startButton];
    
    _stopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 80, 30)];
    _stopButton.backgroundColor = [UIColor greenColor];
    [_stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [[self.stopButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (x) {
            [self stopVoiceRecord];
        }
    }];
    [self.view addSubview:_stopButton];
    
}

-(void)configSpeechRecognizer{
    if (!_recognizer) {
        NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        _recognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
        _recognizer.delegate = self;
    }
}

-(void)startVoiceRecord{
    if (self.recongitionTask) {
        [self.recongitionTask cancel];
        self.recongitionTask = nil;
    }
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc]init];
    }
    
    //要不要无所谓
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    BOOL useful = YES;
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    if (!error) {
        useful = [session setMode:AVAudioSessionModeMeasurement error:&error];
        useful = [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if (useful) {
            NSLog(@"useful");
        }else{
            NSLog(@"useless");
        }
    }else{
        NSLog(@"error0:%@",error);
    }
    //没有也行
    _recongizerRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    AVAudioInputNode *inputNode = _audioEngine.inputNode;
    if (!inputNode) {
        NSLog(@"录入设备没有好");
    }
    if (!_recongizerRequest) {
        NSLog(@"请求初始化失败");
    }
    _recongizerRequest.shouldReportPartialResults = YES;
    @weakify(self);
    self.recongitionTask = [self.recognizer recognitionTaskWithRequest:_recongizerRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        @strongify(self);
        if (result) {
            NSLog(@"result:%@",result);
            self.speechLabel.text = [[result bestTranscription] formattedString];
        }
        [self dealResult:result];
        if (error) {
            NSLog(@"error1:%@",error);
            [self.audioEngine stop];
//            [inputNode removeTapOnBus:0];
            self.recongizerRequest = nil;
            self.recongitionTask = nil;
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        @strongify(self);
        if (self.recongizerRequest) {
            [self.recongizerRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [_audioEngine prepare];
    [_audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"engine error:%@",error);
    }
}

-(void)stopVoiceRecord{
    if (_audioEngine) {
        [_audioEngine stop];
    }
    if (_recongizerRequest) {
        [_recongizerRequest endAudio];
    }
    if (_recongitionTask) {
        [_recongitionTask cancel];
        _recongitionTask = nil;
    }
}

- (void)dealResult:(SFSpeechRecognitionResult*)result{
    if (!result) {
        return;
    }
    NSString *resultBestStr = [[result bestTranscription] formattedString];
    if ([resultBestStr hasPrefix:@"跳到首页"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - delegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
//    NSLog(@"ssss:%@",available);
}
@end
