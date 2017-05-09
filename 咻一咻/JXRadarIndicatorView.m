//
//  JXRadarIndicatorView.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXRadarIndicatorView.h"

@implementation JXRadarIndicatorView


- (void)drawRect:(CGRect)rect {
    
    [self drawIndicator];
    
}


- (void)drawIndicator{
    
    CGFloat radius = self.bounds.size.width * 0.5;
    
    
#pragma mark - 画一个小的圆弧
    //An opaque type that represents a Quartz 2D drawing environment.
    // 1.一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
    UIColor *aColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:1.0];
    
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, aColor.CGColor); // 画笔颜色
    
    CGContextSetLineWidth(context, 0);//线的宽度
    
    //以self.radius为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    // CGContextAddArc(context, self.center.x, self.center.y, self.radius,  -89.7 * M_PI / 180, -90  * M_PI / 180, 1);
    
    CGContextAddArc(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, radius,  -90.5 * M_PI / 180, -90  * M_PI / 180, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    
    
    
    //多个小扇形构造渐变的大扇形  直角扇形
    for (int i = 0; i<= 90; i++) {
        //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
        UIColor *aColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:i/500.0f];
        
        
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, 0);//线的宽度
        //以self.radius为半径围绕圆心画指定角度扇形
        CGContextMoveToPoint(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        CGContextAddArc(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, radius,  (-180 + i) * M_PI / 180, (-180 + i - 1) * M_PI / 180, 1);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    }
    
    
}

@end
