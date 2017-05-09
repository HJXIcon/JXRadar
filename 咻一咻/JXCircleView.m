//
//  JXCircleView.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCircleView.h"

/// 圆圈数
static int  const kDefaultCircleCount = 1;
@implementation JXCircleView


- (void)drawRect:(CGRect)rect {

    
    CGFloat radius = 30;
    
    NSArray *alpha = @[@1.0,@.6,@.4,@.2];
    
    [self drawCircleView1WithRadius:radius alpha:[alpha[3] floatValue]];
    
    
    
//    [self drawCircleView2];
    
//    [self drawText:CGRectMake(0, 0, self.frame.size.width, 40)];
    
//    [self drawImage:rect];
    
}



// 画图片
- (void)drawImage:(CGRect)rect{
    //1.获取当前的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //2.加载图片
    //这里顺便咯嗦一句：使用imageNamed加载图片是会有缓存的
    //我们这里只需要加载一次就够了，不需要多次加载，所以不应该保存这个缓存
    //    UIImage * image = [UIImage imageNamed:@"222"]; //所以可以换一种方式去加载
    UIImage * image = [UIImage imageNamed:@"222"]; //所以可以换一种方式去加载
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"222.png" ofType:nil]];
    
    //    //绘制的大小位置
    //    [image drawInRect:rect];
    
    
    //    //从某个点开始绘制
    //    [image drawAtPoint:CGPointMake(0, 0)];
    
    
    //绘制一个多大的图片，并且设置他的混合模式以及透明度
    //Rect：大小位置
    //blendModel：混合模式
    //alpha：透明度
    [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
    
    
    //从某一点开始绘制图片，并设置混合模式以及透明度
    //point:开始位置
    //blendModel：混合模式
    //alpha：透明度
    //    [image drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1];
    
    //添加到上下文
    CGContextFillPath(contextRef);
    
}


// 画文字
- (void)drawText:(CGRect)rect{
    //1.获取当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //2.创建文字
    NSString * str = @"纸巾艺术";
    
    //会知道上下文
    
    //设置字体样式
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //NSFontAttributeName:字体大小
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:25];
    //字体前景色
    dict[NSForegroundColorAttributeName] = [UIColor blueColor];
    //字体背景色
    dict[NSBackgroundColorAttributeName] = [UIColor redColor];
    //字体阴影
    NSShadow * shadow = [[NSShadow alloc]init];
    //阴影偏移量
    shadow.shadowOffset = CGSizeMake(2, 2);
    //阴影颜色
    shadow.shadowColor = [UIColor greenColor];
    //高斯模糊
    shadow.shadowBlurRadius = 5;
    dict[NSShadowAttributeName] = shadow;
    //字体间距
    dict[NSKernAttributeName] = @10;
    // 11.1设置段落风格
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    //    paragraph.alignment = NSTextAlignmentCenter;
    dict[NSParagraphStyleAttributeName] = paragraph;
    
    
    [str drawInRect:rect withAttributes:dict];
    CGContextStrokePath(contextRef);
    
}



- (void)drawCircleView2{
    
    /*! 画圆方法2 */
    
    /*!
     UIBezierPath主要用来绘制矢量图形，它是基于Core Graphics对CGPathRef数据类型和path绘图属性的一个封装，所以是需要图形上下文的（CGContextRef），所以一般UIBezierPath在drawRect中使用
     */
    
    // 画圆
    CGFloat radius = 40;
    
    //
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    // 创建圆弧
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:1.0].CGColor;
    
    layer.fillColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:1.0].CGColor;
    
    [self.layer addSublayer:layer];

}


- (void)drawCircleView1WithRadius:(CGFloat)radius alpha:(CGFloat)alpha{
    

    /*！画圆方法1 */
    /*!
     1 获取当前的上下文（这里只能获取一次，并且只能在drawRect方法中获取）
     2 描述路径、形状（就是处理想要显示的样子）
     3 把描述好的路径、形状添加早上下文中
     4 显示上下文内容
     
     */
    
    // 1.开启上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.描述路径、形状
    //  最后一个参数是否逆时针
    UIBezierPath *path0 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO];
    
    //3.添加路径到上下文
    CGContextAddPath(ctx, path0.CGPath);
    
    
    UIColor *color = [UIColor colorWithRed:0 green:191 blue:255 alpha:alpha];
    
    //4.设置颜色
    [color setFill];
    [color setStroke];
    
    
    //5.显示上下文 显示一个实心圆
    CGContextFillPath(ctx);
    //显示一个空心圆，描边
    //    CGContextStrokePath(ctx);
}




#pragma mark - 添加水印

/// 给图片添加文字水印：
+ (UIImage *)jx_WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}


+ (UIImage *)jx_WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect{
    
    //1.获取图片
    
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}


#pragma mark - 截屏
+ (void)jx_cutScreenWithView:(nullable UIView *)view successBlock:(nullable void(^)(UIImage * _Nullable image,NSData * _Nullable imagedata))block{
    //1、开启上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    //2.获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //3.截屏
    [view.layer renderInContext:ctx];
    
    //4、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.转化成为Data
    //compressionQuality:表示压缩比 0 - 1的取值范围
    NSData * data = UIImageJPEGRepresentation(newImage, 1);
    //6、关闭上下文
    UIGraphicsEndImageContext();
    
    //7.回调
    block(newImage,data);
}





@end
