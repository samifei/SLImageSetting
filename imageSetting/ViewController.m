//
//  ViewController.m
//  imageSetting
//
//  Created by ttxc on 2017/11/13.
//  Copyright © 2017年 TTXC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    __weak IBOutlet UIImageView *oldImage;
    __weak IBOutlet UIImageView *newImage;
    
    UIImage *slimage;
    UIImage *lfimage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    slimage = [UIImage imageNamed:@"4.jpeg"];
    lfimage = [UIImage imageNamed:@"Icon-lf"];
}
- (IBAction)文字:(id)sender {
    newImage.image = [self addImage:slimage text:@"SamLi" withFont:[UIFont systemFontOfSize:40.0] withRect:CGRectMake(20,20, 200, 200)];
}
- (IBAction)图片:(id)sender {
    newImage.image = [self addToImage:slimage image:lfimage withRect:CGRectMake(20,20, 200, 200)];
}
- (IBAction)压缩图片:(id)sender {
    //压缩图片并保存
    [self zipImageData:slimage];
}
- (IBAction)裁剪:(id)sender {
    newImage.image = [self cutImage:slimage withRect:CGRectMake(300, 300, 100, 100)];
}
- (IBAction)压缩图形:(id)sender {
    newImage.image = [self scaleToSize:slimage size:CGSizeMake(100, 100)];
}

#pragma mark -
//压缩图形
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 设置成为当前context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return scaledImage;
}

//截图图片
- (UIImage *)cutImage:(UIImage *)image withRect:(CGRect )rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

//压缩图片保存
- (void)zipImageData:(UIImage *)image
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHSSS"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateStr = [NSString stringWithFormat:@"%@.jpg",currentDateStr];
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:dateStr];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    
    if([imgData writeToFile:path atomically:YES])
    {
        NSLog(@"saveSuccess");
    }
}
//加文字水印
- (UIImage *) addImage:(UIImage *)img text:(NSString *)mark withFont:(UIFont *)font withRect:(CGRect)rect
{
    int w = img.size.width;
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    [[UIColor redColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    if([[[UIDevice currentDevice]systemName]floatValue] >= 7.0)
    {
        //ios 7.0以上
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,[UIColor blueColor] ,NSForegroundColorAttributeName,nil];
        [mark drawInRect:rect withAttributes:dic];
    }
    else
    {
        //7.0及其以后都废弃了,完全可以不写这个判断
        [mark drawInRect:rect withFont:font];
    }
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

//加图片水印
- (UIImage *) addToImage:(UIImage *)img image:(UIImage *)newImage withRect:(CGRect)rect
{
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    [newImage drawInRect:rect];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
