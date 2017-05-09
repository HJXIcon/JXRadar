
//
//  JXRadarViewController.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXRadarViewController.h"
#import "JXRadarView.h"
#import "JXRadarPointView.h"

@interface JXRadarViewController ()<JXRadarViewDataSource,JXRadarViewDelegate>


@property (nonatomic, weak)JXRadarView *radarView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UILabel *searchLabel;

@end

@implementation JXRadarViewController


- (UILabel *)searchLabel{
    if (_searchLabel == nil) {
        _searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 80, 200, 35)];
        _searchLabel.text = @"正在搜索附近的人...";
        _searchLabel.textColor = [UIColor blueColor];
        _searchLabel.backgroundColor = [UIColor clearColor];
        _searchLabel.textAlignment = NSTextAlignmentCenter;
        [_searchLabel.layer addAnimation:[self opacityForever_Animation:0.5] forKey:@"searchAnimation"];
    }
    return _searchLabel;
}


- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
        for (int i = 0; i < 4; i ++) {
            [_dataArray addObject:[NSString stringWithFormat:@"%d",i + 1]];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"雷达";
    
    JXRadarView *radarView = [[JXRadarView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.radarView = radarView;
    
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = self.view.bounds.size.width * 0.5;
    
    radarView.centerPersonImage = [UIImage imageNamed:@"222"];
    [radarView scan];
    
    [self.view addSubview:radarView];
    
    
    /// 模拟网络加载数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.radarView reloadData];
        
        // 移除动画
        [self.searchLabel.layer removeAnimationForKey:@"searchAnimation"];
        self.searchLabel.text = @"搜索结果:";
        
    });
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重新搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    
    [self.view addSubview:self.searchLabel];
}


- (void)rightClick{
    
    [self.radarView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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




#pragma mark - JXRadarViewDataSource

- (NSInteger)numberOfPointsInRadarView:(JXRadarView *)radarView{
    return self.dataArray.count;
}

/*! 展示 */
- (JXRadarPointView *)radarView:(JXRadarView *)radarView viewForIndex:(NSUInteger)index{
    
    /// 1.创建pointView
    JXRadarPointView *pointView = [[JXRadarPointView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    pointView.imageName = self.dataArray[index];
    
    // 2.随机角度
    NSString *jiaodu = [NSString stringWithFormat:@"%d",arc4random()%360];
    // 计算半径
    int radarradius = self.radarView.radius - self.radarView.imgradius - 40;//雷达半径-头像半径-poing半径，表示在雷达中，头像外；
    int iamgeRadius = self.radarView.imgradius + 20;
    int banban = (arc4random()%radarradius) + iamgeRadius;
    NSString *banjing = [NSString stringWithFormat:@"%d",banban];
    
    NSLog(@"radarView.radius == %f",self.radarView.radius);
    NSLog(@"radarView.imgradius == %f",self.radarView.imgradius);
    NSLog(@"banban == %d",banban);
    NSLog(@"banjing == %@",banjing);
    
    pointView.pointAngle = jiaodu;
    pointView.pointRadius = banjing;
    
    return pointView;
    
}

- (void)radarView:(JXRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"%ld",index);
}

@end
