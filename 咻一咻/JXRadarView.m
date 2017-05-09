//
//  JXRadarView.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXRadarView.h"
#import "JXRadarIndicatorView.h"
#import "JXRadarPointView.h"


/*! 默认半径 */
static int const kDefaultRadius = 140;
/*! 默认圈数 */
static int const kDefaultCircleNumber = 5;
/*! 默认中间图片半径 */
static int const kDefaultImgradius = 15;

/*! 默认间隔比例 */
static CGFloat const kDefaultMagrinSacle = .4; //0 ~ 1
/*! 转速 */
static CGFloat const kRotateSpeed = 80.0;

/*! 默认展示延迟时间 */
static CGFloat const kDefaultDelayDuration = 1.0; //



@interface JXRadarView ()

/** 指示器*/
@property (nonatomic, strong)JXRadarIndicatorView *indicatorView;
/** 目标点视图父视图 */
@property (nonatomic, strong) UIView *pointsView;
@property (nonatomic, strong) NSMutableArray *pointsViewArray;
@end

@implementation JXRadarView
#pragma mark - lazy loading
- (JXRadarIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[JXRadarIndicatorView alloc]init];
    }
    return _indicatorView;
}

- (NSMutableArray *)pointsViewArray{
    if (_pointsViewArray == nil) {
        _pointsViewArray = [NSMutableArray array];
    }
    return _pointsViewArray;
}


- (UIView *)pointsView{
    if (_pointsView == nil) {
        _pointsView = [[UIView alloc]initWithFrame:self.bounds];
    }
    return _pointsView;
}

#pragma mark - getter

- (CGFloat)radius{
   
    return _radius == 0 ? kDefaultRadius : _radius;
}


- (CGFloat)imgradius{
    return _imgradius == 0 ? kDefaultImgradius : _imgradius;
}


- (void)drawRect:(CGRect)rect {
    
    
    
    // 0.画背景
    [self drawBgImage:rect];
    
    
    // 1. 画许多圆弧
    [self drawRadius];
    
    
    // 2.添加中间头像
    CGFloat imgradius = kDefaultImgradius;
    if (self.imgradius) {
        imgradius = self.imgradius;
    }
    
    if(self.centerPersonImage && imgradius)
    {
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - imgradius, self.center.y -imgradius - 64, imgradius * 2, imgradius * 2)];
        avatarView.layer.cornerRadius = self.imgradius;
        avatarView.layer.masksToBounds = YES;
        
        avatarView.layer.cornerRadius = imgradius;
        avatarView.layer.masksToBounds = YES;
        [avatarView setImage:self.centerPersonImage];
        [self addSubview:avatarView];
        [self bringSubviewToFront:avatarView];
    }
    
    
    
    
    // 3.添加指示器
    
    CGFloat margin = 60;
    CGFloat indicatorViewWH = self.bounds.size.width + margin;

    self.indicatorView.frame = CGRectMake(- margin * 0.5 , (self.bounds.size.height  - indicatorViewWH) * 0.5, indicatorViewWH, indicatorViewWH);
    self.indicatorView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.indicatorView];
    
    
    // 4.添加目标点父视图
    [self addSubview:self.pointsView];
    
    
}

// 画许多圆弧
- (void)drawRadius{
    
    // 1.默认的圈数
    NSUInteger sectionsNum = kDefaultCircleNumber;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInRadarView:)]) {
        sectionsNum = [self.dataSource numberOfSectionsInRadarView:self];
    }
    
    
    // 2.圆圈半径
    CGFloat radius = kDefaultRadius;
    if (self.radius) {
        radius = self.radius;
    }
    
    
    // 3.中间图片半径
    CGFloat imgradius = kDefaultImgradius;
    if (self.imgradius) {
        imgradius = self.imgradius;
    }
    
   
    // 4.画多个圆圈
    // 4.1中心头像距离最外圈的距离
    CGFloat detaRadius = (radius - imgradius);
    
    // 4.2 每个圆圈的半径
    CGFloat sectionRadius = imgradius;
    
    // 4.3间隔比例
    CGFloat magrinSacle = kDefaultMagrinSacle;
    
    if (self.marginSacle) {
        if (self.marginSacle > 1.0) {
            magrinSacle = 1.0;
        } else if (self.marginSacle < 0.0){
            magrinSacle = 0.0;
        } else{
            magrinSacle = self.marginSacle;
        }
        
    }
    
    CGFloat magrin = detaRadius / sectionsNum * magrinSacle;

    
    for (int i = 1; i < sectionsNum + 1; i++) {
        
        // 每个圆圈半径
        sectionRadius += i * magrin;
        
        
        /*! 画圆*/
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //边框圆
        //画笔线的颜色(透明度渐变)
        
        UIColor *aColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:i/(sectionsNum * 1.0)];
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//填充颜色
        
        CGContextSetLineWidth(context, 1.0);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, sectionRadius, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
        
        
    }
    
    
    
    
}

- (void)drawBgImage:(CGRect)rect{
    
    
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


#pragma mark - 动画
//转动
- (void)scan {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 360.f/kRotateSpeed;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [self.indicatorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop {
    [self.indicatorView.layer removeAnimationForKey:@"rotationAnimation"];
}

/// 更新数据源
- (void)reloadData{
    
    [self showPointViews];
}

#pragma mark - 搜索到用户

//搜索到用户
- (void)showPointViews {
    
    // 1.移除所有点
    if (self.pointsViewArray) {
        for (UIView *view in self.pointsViewArray) {
            [view removeFromSuperview];
        }
         [self.pointsViewArray removeAllObjects];
    }
    
    // 2.目标点数量
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPointsInRadarView:)]) {
        NSUInteger pointsNum = [self.dataSource numberOfPointsInRadarView:self];
        
        // 3.添加每一个点数
        for (int index = 0; index < pointsNum; index++) {
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(radarView:viewForIndex:)]) {
                
                //CGPoint point = [self.dataSource radarView:self positionForIndex:index];
                
                JXRadarPointView *pointView = [self.dataSource radarView:self viewForIndex:index];
                //方向(角度)
                int posDirection = pointView.pointAngle.intValue;
                //距离(半径)
                int posDistance = pointView.pointRadius.intValue;
                
                pointView.tag = index;
                pointView.userInteractionEnabled = YES;
                // 添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
                [pointView addGestureRecognizer:tap];
                
                pointView.layer.cornerRadius = pointView.frame.size.width * 0.5;
                pointView.layer.masksToBounds = YES;
                
                // 4.计算坐标点
                pointView.center = CGPointMake(self.center.x +posDistance * cos(posDirection * M_PI / 180), self.center.y + posDistance * sin(posDirection * M_PI /180));
                //pointView.delegate = self;
                
                // 5.展示动画
                pointView.alpha = 0.0;
                CGAffineTransform fromTransform =
                CGAffineTransformScale(pointView.transform, 0.1, 0.1);
                [pointView setTransform:fromTransform];
                
                CGAffineTransform toTransform = CGAffineTransformConcat(pointView.transform,  CGAffineTransformInvert(pointView.transform));
                
                //int jiange=arc4random()%30;
                
                // 6.动画延迟时间
                double delayInSeconds = kDefaultDelayDuration * index;
                if (self.delayDuration) {
                    delayInSeconds = self.delayDuration * index;
                }
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.5];
                    pointView.alpha = 1.0;
                    [pointView setTransform:toTransform];
                    [UIView commitAnimations];
                });
                
                [self.pointsView addSubview:pointView];
                [self.pointsViewArray addObject:pointView];
            }
        }
    }
    
}



#pragma mark - Actions
- (void)tap:(UITapGestureRecognizer *)tap{
    
    JXRadarPointView *view = (JXRadarPointView *)tap.view;
    
    
    if ([self.delegate respondsToSelector:@selector(radarView:didSelectItemAtIndex:)]) {
        
        [self.delegate radarView:self didSelectItemAtIndex:view.tag];
    }
    
}



@end
