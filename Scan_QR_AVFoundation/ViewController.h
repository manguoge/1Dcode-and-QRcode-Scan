//
//  ViewController.h
//  Scan_QR_AVFoundation
//
//  Created by comfouriertech on 16/9/1.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//运用AVFoundation框架实现二维码扫描

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef enum
{
    up,
    down
}
upOrDown;//描述扫描线的上下限位置
@interface ViewController : UIViewController
{
    int num;
    upOrDown upDown;
    
}
@property (atomic,weak) AVCaptureVideoPreviewLayer* preView;//预览视图层
@property (atomic,strong) AVCaptureDevice* camera;
@property (atomic,strong) AVCaptureDeviceInput* input;
@property (atomic,strong) AVCaptureMetadataOutput* output;
@property (atomic,strong) AVCaptureSession* session;
@property (strong) NSTimer* timer;
@property (strong,nonatomic) UIImageView* scanRectImageView;//取景框视图
@property (strong,nonatomic) UIImageView* lineImageView;//扫描线视图
@end

