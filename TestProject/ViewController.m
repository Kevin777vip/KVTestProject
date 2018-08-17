//
//  ViewController.m
//  TestProject
//
//  Created by fb on 2018/2/24.
//  Copyright © 2018年 fb. All rights reserved.
//

#import "ViewController.h"
#import "DeviceIPAddress.h"
# import <CoreTelephony/CTTelephonyNetworkInfo.h>
# import <CoreTelephony/CTCarrier.h>
#import "VideoRecordViewController.h"
#import <ReactiveObjC.h>
#import "KVVideoRecorder.h"
#import "FBCardModel.h"
#import "HomePageModel.h"
#import "KVTextField.h"
@interface ViewController ()
@property (nonatomic,strong)CAShapeLayer *testShaplayer;
@property (nonatomic,strong)KVVideoRecorder *recorder;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view, typically from a nib.
//    [self configUI];
//    [self configRoundShape];
//    [self configButton];
//    [self readList];
//    NSLog(@"%@",[DeviceIPAddress getIPAddress:YES]);
//    [self simCard];
//    [self testFunction];
//    [self testVideoRecord];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 100, 40)];
    [button setTitle:@"测试app间跳转" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (x) {
//            [self testOpenurl];
//            [self testRequest];
            [self testJumpToVideo];
        }
    }];
    [self.view addSubview:button];
}

-(void)testJumpToVideo{
    VideoRecordViewController *vc = [[VideoRecordViewController alloc]initWithVideoName:@"abc"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)testTextField{
    KVTextField *field = [[KVTextField alloc]initWithFrame:CGRectMake(0, 180, 200, 40)];
    field.backgroundColor = [UIColor greenColor];
    field.kv_allowTextLength = 5;
    [self.view addSubview:field];
    
    KVTextField *fieldw = [[KVTextField alloc]initWithFrame:CGRectMake(0, 180+60, 200, 40)];
    fieldw.backgroundColor = [UIColor yellowColor];
    fieldw.kv_allowTextLength = 15;
    [self.view addSubview:fieldw];
}

-(void)testRequest{
    NSString *urlStr = @"http://172.16.15.62:8484/faceSignRecord/saveFaceSignRecord";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"123456" forKey:@"faceId"];
    [dict setObject:@"18618310772" forKey:@"creater"];

    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i<dict.allKeys.count; i++) {
        NSString *key = dict.allKeys[i];
        NSString *vaule = [dict objectForKey:key];
        [array addObject:[NSString stringWithFormat:@"%@=%@",key,vaule]];
    }
    NSString *formStr = [array componentsJoinedByString:@"&"];
    
    request.HTTPBody = [formStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [task resume];
}

-(void)testOpenurl{
    NSURL *url = [NSURL URLWithString:@"FBFaceSign://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)testModels{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"a",@"msg", nil];
    HomePageModel *home = [[HomePageModel alloc]initWithDictionary:dict error:nil];

    if (home.data.abcd) {
        NSLog(@"has");
    }else{
        NSLog(@"no");
    }
}

- (void)testVideoRecord {
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (x) {
//            VideoRecordViewController *videoVC = [[VideoRecordViewController alloc]init];
//            [self.navigationController pushViewController:videoVC animated:YES];
            self.recorder = [[KVVideoRecorder alloc]initWithPresentView:self.view];
//            [self.recorder configRecordingLabelWithText:@"请大声朗读：一二三四五六七"];
            [self.recorder startRecordingWithFileName:@"09090"];
//            self.recorder.finishedBlock = ^(NSInteger recordedDuration, NSError *error) {
//                NSLog(@"finished:%ld",(long)recordedDuration);
//            };

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"6.....");
                [self.recorder configCameraPosition:AVCaptureDevicePositionBack];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.recorder stopCapture];
                NSLog(@"10.....");
            });
        }
    }];
}

- (void)testImageSave {
//    [kCGImageSourceShouldCache]
}

- (void)testFunction {
    for (int i=0; i<10000; i++) {
//        @autoreleasepool {
            NSString *str = @"abc";
            str = [str lowercaseString];
            str = [str stringByAppendingString:@"xyz"];
//        }
    }
}

- (void)simCard{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSLog(@"carrirer:%@",carrier);
}

- (void)readList{
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fengbang" ofType:@"plist"]];
    
    NSLog(@"data:%@",dataDict);
}

- (void)configButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 200, 40)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked {
//    [self testSemaphore];
//    [self testOperationDependency];
    [self testSemaphoreTest];
}

- (void)configUI {
    [self setCropRect:CGRectMake((self.view.bounds.size.width-200)/2,
                                 (self.view.bounds.size.height-200)/2, 200, 200)];
}

- (void)configRoundShape {
    self.view.backgroundColor = [UIColor whiteColor];
    _testShaplayer = [[CAShapeLayer alloc]init];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:self.view.bounds.size.width/2 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [roundPath appendPath:rectPath];

    [_testShaplayer setFillRule:kCAFillRuleEvenOdd];
    [_testShaplayer setPath:roundPath.CGPath];
    [_testShaplayer setFillColor:[UIColor blackColor].CGColor];
    [_testShaplayer setOpacity:0.6];
    
    [_testShaplayer setNeedsDisplay];
    
    [self.view.layer addSublayer:_testShaplayer];
}

- (void)setCropRect:(CGRect)cropRect{
    _testShaplayer= [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [_testShaplayer setFillRule:kCAFillRuleEvenOdd];
    [_testShaplayer setPath:path];
    [_testShaplayer setFillColor:[UIColor blackColor].CGColor];
    [_testShaplayer setOpacity:0.6];
    
    
    [_testShaplayer setNeedsDisplay];
    
    [self.view.layer addSublayer:_testShaplayer];
    
}

- (void)testSemaphoreTest{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);//创建总数为0的信号
    for (int i=0; i<100; ++i) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"number:%d thread:%@",i,[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);//发送信号，信号+1
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)testSemaphore{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);//创建总数为0的信号
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);//发送信号，信号+1
    });
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);//等待信号，当信号量少于0时就会一直等待，否则正常执行，并使信号量-1
    NSLog(@"5");
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);//发送信号，信号+1
    });
    NSLog(@"6");
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);

    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);//+1
    });
    NSLog(@"7");
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"4:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);//+1
    });
//    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    NSLog(@"end:%@",semaphore);
}

- (void)textAction {
    
    
    
    
    
    NSThread *current = [NSThread currentThread];
    NSLog(@"current:%@",current);
    
    [NSThread sleepForTimeInterval:2];
    NSLog(@"finish");
    
    //主线程，串行
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //全局队列，并行
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //自定义串行
    dispatch_queue_t serialQueue = dispatch_queue_create("com.kevin.abcd", DISPATCH_QUEUE_SERIAL);
    //自定义并行
    dispatch_queue_t concurrentQueue =dispatch_queue_create("com.kevin.efgh", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, concurrentQueue, ^{
        //执行第一个任务
        dispatch_group_enter(group);
        dispatch_group_leave(group);
    });
    dispatch_group_async(group, concurrentQueue, ^{
        //执行第二个任务
    });
    
    dispatch_group_notify(group, concurrentQueue, ^{
        //group 中的任务执行完
    });
    
    
    
    
    dispatch_queue_t queue;
    //异步
    dispatch_async(queue, ^{
        //
    });
    //同步
    dispatch_sync(queue, ^{
        //
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //
    });
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只执行一次
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // code to be executed after a specified delay
    });
    
    
    dispatch_queue_t concurrentQueueTwo = dispatch_queue_create("com.kevin.concue=rrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2");
    });
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"barrier");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"3");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"4");
    });
 
}

-(void)testOperationDependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //
        NSLog(@"1");
    }];
    
    NSBlockOperation *operationTwo = [NSBlockOperation blockOperationWithBlock:^{
        //
        [NSThread sleepForTimeInterval:5];
        NSLog(@"2");
    }];
    
    NSBlockOperation *operationThree = [NSBlockOperation blockOperationWithBlock:^{
        //
        NSLog(@"3");
    }];
    [operation addDependency:operationTwo];
    
    [queue addOperation:operation];
    [queue addOperation:operationTwo];
    [queue addOperation:operationThree];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
