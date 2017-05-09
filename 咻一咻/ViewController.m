//
//  ViewController.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "JXCircleView.h"
#import "JXRadarViewController.h"
#import "JXRadarPointView.h"

@interface ViewController ()<CAAnimationDelegate>

@property(nonatomic, strong) UILabel *searchLabel;

@property(nonatomic, strong) NSMutableArray *circleArray;

/** 目标点视图父视图 */
@property (nonatomic, strong) UIView *pointsView;
@property (nonatomic, strong) NSMutableArray *pointsViewArray;

@property(nonatomic, weak) JXCircleView *circleView;

/** 是否展示目标头像*/
@property (nonatomic, assign)BOOL isNeedShow;

@end



@implementation ViewController
- (NSMutableArray *)circleArray{
    if (_circleArray == nil) {
        _circleArray = [NSMutableArray array];
    }
    return _circleArray;
}

- (UIView *)pointsView{
    if (_pointsView == nil) {
        _pointsView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height  -64)];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_pointsView];
    }
    return _pointsView;
}

- (NSMutableArray *)pointsViewArray{
    if (_pointsViewArray == nil) {
        _pointsViewArray = [NSMutableArray array];
    }
    return _pointsViewArray;
}


- (UILabel *)searchLabel{
    if (_searchLabel == nil) {
        _searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 100, 200, 35)];
        _searchLabel.text = @"正在搜索附近的人...";
        _searchLabel.textColor = [UIColor blueColor];
        _searchLabel.textAlignment = NSTextAlignmentCenter;
        [_searchLabel.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
        _searchLabel.backgroundColor = [UIColor colorWithRed:255.0/231 green:255.0/231 blue:255.0/233 alpha:1.0];
    }
    return _searchLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"咻一咻";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"雷达" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    [self.view addSubview:self.searchLabel];
    
    CGRect CGFrome = self.view.bounds;
//    
//    JXCircleView *circleView = [[JXCircleView alloc]init];
//    circleView.frame = CGRectMake(30, 150, CGFrome.size.width-60, CGFrome.size.width-60);
//    circleView.backgroundColor = [UIColor clearColor];
//    _circleView = circleView;
//    
//    [_circleView.layer addAnimation:[self addGroupAnimation] forKey:@"groupAnimation1"];
//    [self.view addSubview:circleView];
    
    
    
    
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        JXCircleView *circleView1 = [[JXCircleView alloc]init];
        circleView1.frame = CGRectMake(30, 150, CGFrome.size.width-60, CGFrome.size.width-60);
        circleView1.backgroundColor = [UIColor clearColor];
        
        [circleView1.layer addAnimation:[weakSelf addGroupAnimation] forKey:@"groupAnimation2"];
        [weakSelf.view addSubview:circleView1];
        
        
        [weakSelf.circleArray addObject:circleView1];
    }];

    
    
    
    
    
}



- (void)rightClick{
    JXRadarViewController *radarVC = [[JXRadarViewController alloc]init];
    [self.navigationController pushViewController:radarVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isNeedShow = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showPointViews];
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.pointsView removeFromSuperview];
    self.pointsView = nil;
    self.isNeedShow = NO;
}


#pragma mark - 搜索到用户

//搜索到用户
- (void)showPointViews {
    
    // 0.是否展示pointViews
    if (!self.isNeedShow) {
        return;
    }
    
    // 1.移除所有点
    if (self.pointsViewArray) {
        for (UIView *view in self.pointsViewArray) {
            [view removeFromSuperview];
        }
        [self.pointsViewArray removeAllObjects];
    }
    
    // 2.目标点数量
    NSUInteger pointsNum = 4;
    
        // 3.添加每一个点数
        for (int index = 0; index < pointsNum; index++) {
                
                //CGPoint point = [self.dataSource radarView:self positionForIndex:index];
                
                JXRadarPointView *pointView = [[JXRadarPointView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            
            
            // 2.随机角度
            NSString *jiaodu = [NSString stringWithFormat:@"%d",arc4random()%360];
            // 计算半径
            int radarradius = self.view.frame.size.width * 0.5 - 40;
            int iamgeRadius = 20;
            int banban = (arc4random()%radarradius) + iamgeRadius;
            NSString *banjing = [NSString stringWithFormat:@"%d",banban];
        
            
            pointView.pointAngle = jiaodu;
            pointView.pointRadius = banjing;
            
            pointView.imageName = [NSString stringWithFormat:@"%d",index + 1];
            //方向(角度)
            int posDirection = jiaodu.intValue;
            //距离(半径)
            int posDistance = banjing.intValue;
                
            pointView.tag = index;
            pointView.userInteractionEnabled = YES;
            // 添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [pointView addGestureRecognizer:tap];
            
            pointView.layer.cornerRadius = pointView.frame.size.width * 0.5;
            pointView.layer.masksToBounds = YES;
            
            // 4.计算坐标点
            CGPoint center = CGPointMake(self.view.center.x +posDistance * cos(posDirection * M_PI / 180), self.view.center.y + posDistance * sin(posDirection * M_PI /180));
            
            // 4.1跟上一个点比较
            CGPoint lastCenter = CGPointZero;
            if (index > 0) {
                JXRadarPointView *lastPointView = self.pointsViewArray[index - 1];
                lastCenter = lastPointView.center;
                
                if (fabs(center.x - lastCenter.x) <= 40 || fabs(center.y - lastCenter.y) <= 40) {
                    
                    CGPoint tmpCenter = CGPointMake(center.x + 40, center.y + 40);
                    center = tmpCenter;
                }
            }
            
            pointView.center = center;
            //pointView.delegate = self;
            
            // 5.展示动画
            pointView.alpha = 0.0;
            CGAffineTransform fromTransform =
            CGAffineTransformScale(pointView.transform, 0.1, 0.1);
            [pointView setTransform:fromTransform];
            
            CGAffineTransform toTransform = CGAffineTransformConcat(pointView.transform,  CGAffineTransformInvert(pointView.transform));
            
            //int jiange=arc4random()%30;
            
            // 6.动画延迟时间
            double delayInSeconds = 1 * index;
            
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


- (void)tap:(UITapGestureRecognizer *)tap{
    
    JXRadarPointView *pointView = (JXRadarPointView *)tap.view;
    NSLog(@"%ld",pointView.tag);
}



/*! 永久闪烁动画 */
- (CABasicAnimation *)opacityForever_Animation:(CGFloat)time{
    
    // 1.实例化，并指定Layer的属性作为关键路径来注册
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    /*!
     1.opacity 透明度
     2.transform ：翻页，渐变，上，下拉进，拉出的效果
     3.bounds：变大变小
     4.position：位置
     */
    
    
    // 2.设定动画起始帧和结束帧
    animation.fromValue = [NSNumber numberWithFloat:1.0f];//起始点
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    
    // 3.动画结束时是否执行逆动画
    animation.autoreverses = YES;
    
    // 4.动画时长
    animation.duration = time;
    
    // 5.重复次数
    animation.repeatCount = MAXFLOAT;
    
    // 6.动画结束后不变回初始状态（防止动画结束后回到初始状态）
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // 7.设置动画的速度变化
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
    
    
}

- (CAAnimationGroup *)addGroupAnimation{
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation1.fromValue = @1;
    animation1.toValue = @7;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @1;
    animation2.toValue = @0;
    
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[animation1,animation2];
    groupAnima.duration = 4;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    groupAnima.repeatCount = 1;
    
    groupAnima.delegate = self;
    return groupAnima;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    UIView *view = self.circleArray.firstObject;
    [self.circleArray removeObjectAtIndex:0];
    [view removeFromSuperview];

}

@end
