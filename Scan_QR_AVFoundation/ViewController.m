//
//  ViewController.m
//  Scan_QR_AVFoundation
//
//  Created by comfouriertech on 16/9/1.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVMetadataObject.h>
#import "PureLayout.h"
#import "NSArray+descrition.h"
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ViewController
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //扫描界面
    self.scanRectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.8 * self.view.frame.size.width, 0.8 * self.view.frame.size.width)];
    self.scanRectImageView.image = [UIImage imageNamed:@"contact_scanframe"];
    [self.view addSubview:self.scanRectImageView];
    [self.scanRectImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.scanRectImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [self.scanRectImageView autoSetDimensionsToSize:CGSizeMake(0.8 * self.view.frame.size.width, 0.8 * self.view.frame.size.width)];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text=@"将取景框对准二维码，即自动扫描";
    [self.view addSubview:labIntroudction];
    [labIntroudction autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.scanRectImageView];
    [labIntroudction autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.scanRectImageView];
    [labIntroudction autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scanRectImageView withOffset:8];
    upDown = up;
    num =0;
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    self.lineImageView.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:self.lineImageView];
    [self.lineImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.scanRectImageView withOffset:40];
    [self.lineImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.scanRectImageView withOffset:-40];
    [self.lineImageView autoSetDimension:ALDimensionHeight toSize:2];
    [self.lineImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scanRectImageView withOffset:10];
    
    [self setupCamera];
    
}
-(void)setupCamera
{
    self.camera=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input=[AVCaptureDeviceInput deviceInputWithDevice:self.camera error:nil];
    self.output=[[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session=[[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    //条码类型,人脸
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeFace,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.preView=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preView.videoGravity=AVLayerVideoGravityResizeAspectFill;
        self.preView.frame=self.view.bounds;
        /////////////////修改检测
        [self.view.layer insertSublayer:self.preView atIndex:0];
        [self.session startRunning];
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.session&&![self.session isRunning])
    {
        [self.session startRunning];
        timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(customAnimation) userInfo:nil repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [timer invalidate];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString* stringValue;
    if ([metadataObjects count]>0)
    {
        //////////测试
        NSLog(@"metadataObjects:%@",metadataObjects);
        
        AVMetadataMachineReadableCodeObject* metaDataObject=[metadataObjects objectAtIndex:0];
        stringValue=metaDataObject.stringValue;
    }
    //[self.session stopRunning];
    [timer invalidate];
    NSLog(@"扫描结果：%@",stringValue);
    
//扫描自己的二维码
//    NSURL* ownUrl=[NSURL URLWithString:@"html/jedgement.html" relativeToURL:[ZXApiClient sharedClient].baseURL].absoluteString];
//    if ([stringValue hasPrefix:url]) {
//        //如果扫出来的url是自己的域名开头的，那么做如下的处理。
//    }
    //扫描别人的二维码
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
}
-(void)customAnimation
{
    if (upDown == up)
    {
        num ++;
        self.lineImageView.frame = CGRectMake(CGRectGetMinX(self.lineImageView.frame), 110+2*num, CGRectGetWidth(self.lineImageView.frame), CGRectGetHeight(self.lineImageView.frame));
        if (2 * num == CGRectGetHeight(self.scanRectImageView.frame) - 20) {
            upDown = down;
        }
    }
    else {
        num --;
        self.lineImageView.frame = CGRectMake(CGRectGetMinX(self.lineImageView.frame), 110+2*num, CGRectGetWidth(self.lineImageView.frame), CGRectGetHeight(self.lineImageView.frame));
        if (num == 0)
        {
            upDown = up;
        }
    }

}
@end
