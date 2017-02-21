//
//  KSShineLable.h
//  KSShineLable
//
//  Created by 康帅 on 17/2/21.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSShineLable : UILabel
/*
 ** 渐淡时长，默认是2.5秒
 */
@property (assign, nonatomic, readwrite) CFTimeInterval shineDuration;

/*
 ** 渐出时长，默认是2.5秒
 */
@property (assign, nonatomic, readwrite) CFTimeInterval fadeoutDuration;

/*
 ** 自动执行动画，默认是NO
 */
@property (assign, nonatomic, readwrite, getter = isAutoStart) BOOL autoStart;

/*
 ** 只读获取显示状态
 */
@property (assign, nonatomic, readonly, getter = isShining) BOOL shining;

/*
 ** 只读获取显示状态
 */
@property (assign, nonatomic, readonly, getter = isVisible) BOOL visible;

/*
 ** 外部方法
 */
- (void)shine;
- (void)shineWithCompletion:(void (^)())completion;
- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)())completion;
@end
