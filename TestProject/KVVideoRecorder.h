//
//  KVVideoRecorder.h
//  TestProject
//
//  Created by fb on 2018/7/24.
//  Copyright © 2018 fb. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^RecordingFinishedBlock)(NSInteger recordedDuration,NSError *error);
typedef void(^RecordingStartedBlock)(void);
@import AVKit;
@interface KVVideoRecorder : NSObject
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureDevice *videoCaptureDevice;
@property (nonatomic,strong)AVCaptureDevice *audioCaptureDevice;
@property (nonatomic,strong)AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong)AVCaptureDeviceInput *audioInput;
@property (nonatomic,strong)AVCaptureMovieFileOutput *fileOutput;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic,copy) RecordingFinishedBlock finishedBlock;
@property (nonatomic,copy) RecordingStartedBlock recordStartedBlock;
@property (nonatomic,strong)UILabel *recordingTextLabel;

-(instancetype)initWithPresentView:(UIView*)view;
//-(void)configRecordingLabelWithText:(NSString*)recordingText;
-(void)configCameraPosition:(AVCaptureDevicePosition)position;
-(void)startRecordingWithFileName:(NSString*)name;
-(void)stopCapture;
@end
