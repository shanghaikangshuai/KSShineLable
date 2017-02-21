//
//  KSShineLable.m
//  KSShineLable
//
//  Created by 康帅 on 17/2/21.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "KSShineLable.h"
@interface KSShineLable ()
@property (strong, nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *characterAnimationDurations;
@property (nonatomic, strong) NSMutableArray *characterAnimationDelays;
@property (strong, nonatomic) CADisplayLink *displaylink;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (assign, nonatomic) CFTimeInterval endTime;
@property (assign, nonatomic, getter = isFadedOut) BOOL fadedOut;
@property (nonatomic, copy) void (^completion)();
@end
@implementation KSShineLable
/*
 ** 支持三种构造方法
 */
-(instancetype)init{
    self=[super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
/*
 ** 初始化参数
 */
-(void)commonInit{
    _shineDuration   = 2.5;
    _fadeoutDuration = 2.5;
    _autoStart       = NO;
    _fadedOut        = YES;
    self.textColor  = [UIColor whiteColor];
    _characterAnimationDurations = [NSMutableArray array];
    _characterAnimationDelays    = [NSMutableArray array];
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedString)];
    //每帧刷新文字颜色，初始暂停，不刷新
    _displaylink.paused = YES;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
}
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    self.attributedString = [self initialAttributedStringFromAttributedString:attributedText];
    [super setAttributedText:self.attributedString];
    for (NSUInteger i = 0; i < attributedText.length; i++) {
        self.characterAnimationDelays[i] = @(arc4random_uniform(self.shineDuration / 2 * 100) / 100.0);
        CGFloat remain = self.shineDuration - [self.characterAnimationDelays[i] floatValue];
        self.characterAnimationDurations[i] = @(arc4random_uniform(remain * 100) / 100.0);
    }
}
/*
 ** 当self被成功添加到视图层级上后调用
 */
-(void)didMoveToWindow{
    //判断拿到的window不为空，并且需要自动执行代码，就开始执行动画
    if (self.window!=nil&&self.autoStart) {
        [self shine];
    }
}
/*
 ** 开始执行渐现动画
 */
- (void)shine
{
    [self shineWithCompletion:NULL];
}
- (void)shineWithCompletion:(void (^)())completion
{
    if (!self.isShining && self.isFadedOut) {
        self.completion = completion;
        self.fadedOut = NO;
        [self startAnimationWithDuration:self.shineDuration];
    }
}
/*
 ** 开始执行渐出动画
 */
- (void)fadeOut
{
    [self fadeOutWithCompletion:NULL];
}

- (void)fadeOutWithCompletion:(void (^)())completion
{
    if (!self.isShining && !self.isFadedOut) {
        self.completion = completion;
        self.fadedOut = YES;
        [self startAnimationWithDuration:self.fadeoutDuration];
    }
}
/*
 ** 执行动画
 */
- (void)startAnimationWithDuration:(CFTimeInterval)duration
{
    self.beginTime = CACurrentMediaTime();
    self.endTime = self.beginTime + self.shineDuration;
    self.displaylink.paused = NO;
}
- (BOOL)isShining
{
    return !self.displaylink.isPaused;
}

- (BOOL)isVisible
{
    return NO == self.isFadedOut;
}
/*
 ** 每帧进行刷新
 */
-(void)updateAttributedString{
    CFTimeInterval now = CACurrentMediaTime();
    for (NSUInteger i = 0; i < self.attributedString.length; i ++) {
        //判断当前字符是否是空格，若是跳过不处理
        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self.attributedString.string characterAtIndex:i]]) {
            continue;
        }
        //枚举指定范围内指定属性名称的值信息和range信息
        [self.attributedString enumerateAttribute:NSForegroundColorAttributeName
                                          inRange:NSMakeRange(i, 1)
                                          options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                       usingBlock:^(id value, NSRange range, BOOL *stop) {
                                           
                                           CGFloat currentAlpha = CGColorGetAlpha([(UIColor *)value CGColor]);
                                           BOOL shouldUpdateAlpha = (self.isFadedOut && currentAlpha > 0) || (!self.isFadedOut && currentAlpha < 1) || (now - self.beginTime) >= [self.characterAnimationDelays[i] floatValue];
                                           
                                           if (!shouldUpdateAlpha) {
                                               return;
                                           }
                                           
                                           CGFloat percentage = (now - self.beginTime - [self.characterAnimationDelays[i] floatValue]) / ( [self.characterAnimationDurations[i] floatValue]);
                                           if (self.isFadedOut) {
                                               percentage = 1 - percentage;
                                           }
                                           UIColor *color = [self.textColor colorWithAlphaComponent:percentage];
                                           [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
                                       }];
    }
    [super setAttributedText:self.attributedString];
    if (now > self.endTime) {
        self.displaylink.paused = YES;
        if (self.completion) {
            self.completion();
        }
    }
}
/*
 ** 传入一个attributedString,返回一个透明的mutableattributedString
 */
-(NSMutableAttributedString *)initialAttributedStringFromAttributedString:(NSAttributedString *)attributedString{
    NSMutableAttributedString *mutableAttributedString=[attributedString mutableCopy];
    UIColor *color=[self.textColor colorWithAlphaComponent:0];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    return mutableAttributedString;
}
@end
