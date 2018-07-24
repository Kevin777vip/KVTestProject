//
//  VideoRecordViewController.m
//  TestProject
//
//  Created by fb on 2018/7/23.
//  Copyright © 2018 fb. All rights reserved.
//

#import "VideoRecordViewController.h"
@import AVKit;
@interface VideoRecordViewController ()<AVCaptureFileOutputRecordingDelegate>
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureDevice *videoCaptureDevice;
@property (nonatomic,strong)AVCaptureDevice *audioCaptureDevice;
@property (nonatomic,strong)AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong)AVCaptureDeviceInput *audioInput;
@property (nonatomic,strong)AVCaptureMovieFileOutput *fileOutput;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic,strong)UILabel *textLabel;
@end

@implementation VideoRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configCamera];
    [self startRecordingWithFileName:@"1212"];
}

- (void)configCamera {
    _session = [[AVCaptureSession alloc]init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    _videoCaptureDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    _videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:_videoCaptureDevice error:nil];
    if ([_session canAddInput:_videoInput]) {
        [_session addInput:_videoInput];
        _videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    _audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    _audioInput = [[AVCaptureDeviceInput alloc]initWithDevice:_audioCaptureDevice error:nil];
    if ([_session canAddInput:_audioInput]) {
        [_session addInput:_audioInput];
    }
    
    _fileOutput = [[AVCaptureMovieFileOutput alloc]init];
    AVCaptureConnection *captureConnection = [_fileOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoStabilizationSupported]) {
        captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
//    _fileOutput.connections = [[NSArray alloc]initWithObjects:captureConnection,nil];
    
    if ([_session canAddOutput:_fileOutput]) {
        [_session addOutput:_fileOutput];
    }
    
    if (![_videoPreviewLayer.connection isEnabled]) {
        [_videoPreviewLayer.connection setEnabled:YES];
    }
    
}

-(void)startRecordingWithFileName:(NSString*)name {
    [_session startRunning];

    NSURL *fileUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *outputURL = [[fileUrl URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"mov"];
    [_fileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_session stopRunning];
        _session = nil;
    });
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"一二三四五六七八，请跟我读";
    [self.view addSubview:_textLabel];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) return device;
    }
    return nil;
}

#pragma mark - delegate
-(void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    
}

-(void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"finish");
}
@end
