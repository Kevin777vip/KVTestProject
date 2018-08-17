//
//  KVVideoRecorder.m
//  TestProject
//
//  Created by fb on 2018/7/24.
//  Copyright © 2018 fb. All rights reserved.
//

#import "KVVideoRecorder.h"
@interface KVVideoRecorder()<AVCaptureFileOutputRecordingDelegate>
@end
@implementation KVVideoRecorder


-(void)startRecordingWithFileName:(NSString *)name{
    [_session startRunning];
    NSURL *fileUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *outputURL = [[fileUrl URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"mov"];
    [_fileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
}


-(void)stopCapture{
    [_session stopRunning];
    _session = nil;
}



-(instancetype)initWithPresentView:(UIView*)view{
    self = [super init];
    if (self) {
        [self configCameraWithView:view];
    }
    return self;
}

- (void)configCameraWithView:(UIView*)view {
    _session = [[AVCaptureSession alloc]init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //use safe top
    _videoPreviewLayer.frame = view.bounds;
    [view.layer addSublayer:_videoPreviewLayer];
    
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
    _fileOutput.movieFragmentInterval = kCMTimeInvalid;
//    AVCaptureConnection *captureConnection = [_fileOutput connectionWithMediaType:AVMediaTypeVideo];
//    if ([captureConnection isVideoStabilizationSupported]) {
//        captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//    }
//    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    //    _fileOutput.connections = [[NSArray alloc]initWithObjects:captureConnection,nil];
    
    if ([_session canAddOutput:_fileOutput]) {
        [_session addOutput:_fileOutput];
    }
    
    if (![_videoPreviewLayer.connection isEnabled]) {
        [_videoPreviewLayer.connection setEnabled:YES];
    }
    
}

-(void)configCameraPosition:(AVCaptureDevicePosition)position {
    
    [_session beginConfiguration];
    [_session removeInput:_videoInput];
    _videoCaptureDevice = [self cameraWithPosition:position];
    NSError *error;
    _videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:_videoCaptureDevice error:&error];
    if (error) {
        [_session commitConfiguration];
        return;
    }
    if ([_session canAddInput:_videoInput]) {
        [_session addInput:_videoInput];
        _videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [_session commitConfiguration];
    }
}

-(void)configRecordingLabelWithText:(NSString *)recordingText {
    _recordingTextLabel = [[UILabel alloc]initWithFrame:_videoPreviewLayer.bounds];
    _recordingTextLabel.textColor = [UIColor blackColor];
    _recordingTextLabel.text = recordingText;
    [_videoPreviewLayer addSublayer:_recordingTextLabel.layer];
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
    if (_recordStartedBlock) {
//        NSInteger second = CMTimeGetSeconds(output.recordedDuration);
        _recordStartedBlock();
    }
}

-(void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    if (_finishedBlock) {
        NSInteger second = CMTimeGetSeconds(output.recordedDuration);
        _finishedBlock(second,error,outputFileURL);
    }
}

@end
