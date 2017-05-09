//
//  JXRadarPointView.h
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 雷达View中搜索的好友view
 */
@interface JXRadarPointView : UIView

/** 角度 */
@property (nonatomic,strong) NSString *pointAngle;
/** 距离中点的距离*/
@property (nonatomic,strong) NSString *pointRadius;
/** 图片*/
@property (nonatomic, strong)NSString *imageName;

@end
