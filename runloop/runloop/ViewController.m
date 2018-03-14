//
//  ViewController.m
//  runloop
//
//  Created by tianyihua on 2018/3/11.
//  Copyright © 2018年 youkuhd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 500, 100, 100)];
    _imageView = imageView;
    [self.view addSubview:imageView];
    
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    NSLog(@"%@",runloop);
    [self observer];
    [self performSelectorTest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)useImageView
{
    // 只在NSDefaultRunLoopMode模式下显示图片
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"placeholder"] afterDelay:3.0 inModes:@[NSDefaultRunLoopMode]];
}

- (void)performSelectorTest {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    self.thread = thread;
    [thread start];
    
}

- (void)run {
//    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:YES modes:@[NSDefaultRunLoopMode]];

    [self performSelector:@selector(test) withObject:nil afterDelay:2.0];

    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [runloop run];
}

- (void)test {
    NSLog(@"-----------------");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)observer {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"监听到即将进入RunLoop------%zd----%@",activity,[[NSRunLoop currentRunLoop] currentMode]);
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"监听到即将处理Timer------%zd----%@",activity,[[NSRunLoop currentRunLoop] currentMode]);
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"监听到即将处理Source------%zd----%@",activity,[[NSRunLoop currentRunLoop] currentMode]);
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"监听到即将进入睡眠------%zd----%@",activity,[[NSRunLoop currentRunLoop] currentMode]);
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"监听到即将从睡眠中醒来------%zd----%@",activity,[[NSRunLoop currentRunLoop] currentMode]);
                break;
            case kCFRunLoopExit:
                NSLog(@"监听到即将从退出RunLoop------%zd----%@",activity,[[NSRunLoop currentRunLoop] currentMode]);
                break;
            default:
                break;
        }
    });
    /*
    CFRunLoopAddObserver函数有三个参数：
    
    第一个：传入一个RunLoop，CFRunLoopGetCurrent()获取当前的RunLoop
    第二个：传入一个观察者，observer就是新创建的观察者
    第三个：传入Mode，kCFRunLoopCommonModes指定要监听的Mode
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    // 释放Observer
    CFRelease(observer);
}

- (void)click {
    NSLog( @"------");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
