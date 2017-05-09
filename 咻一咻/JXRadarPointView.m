//
//  JXRadarPointView.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXRadarPointView.h"

@interface JXRadarPointView()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation JXRadarPointView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    self.imageView.image = [UIImage imageNamed:imageName];
    
}

@end
