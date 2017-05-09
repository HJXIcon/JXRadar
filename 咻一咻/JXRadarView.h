//
//  JXRadarView.h
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXRadarView,JXRadarPointView;

/**
 数据源
 */
@protocol  JXRadarViewDataSource<NSObject>

@optional

/*! 返回圈数 */
- (NSInteger)numberOfSectionsInRadarView:(JXRadarView *)radarView;
/*! 返回搜索目标数 */
- (NSInteger)numberOfPointsInRadarView:(JXRadarView *)radarView;
/*! 展示点view */
- (JXRadarPointView *)radarView:(JXRadarView *)radarView viewForIndex:(NSUInteger)index;

@end


@protocol JXRadarViewDelegate <NSObject>

@optional

- (void)radarView:(JXRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index; //点击事件

@end



/**
 雷达view
 */
@interface JXRadarView : UIView

@property (nonatomic, assign) id <JXRadarViewDataSource> dataSource;
@property (nonatomic, assign) id <JXRadarViewDelegate> delegate;

/** 半径*/
@property (nonatomic, assign)CGFloat radius; // 默认是140

/** 中心点图片的半径*/
@property (nonatomic, assign)CGFloat imgradius; // 默认是15
/** 间隔比例*/
@property (nonatomic, assign)CGFloat marginSacle; // 0.0 ~ 1.0, 默认是0.4
/** 人物背景图片  */
@property (nonatomic, strong) UIImage *centerPersonImage;

/** 个个点展示延迟时间*/
@property (nonatomic, assign)CGFloat delayDuration; // 默认是1秒

// 开始扫描
- (void)scan;
// 停止
- (void)stop;

/// 更新数据源
- (void)reloadData;

@end
