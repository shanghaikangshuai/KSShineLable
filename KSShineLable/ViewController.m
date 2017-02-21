//
//  ViewController.m
//  KSShineLable
//
//  Created by 康帅 on 17/2/21.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "ViewController.h"
#import "KSShineLable.h"
@interface ViewController ()
/*
 ** 文字存储
 */
@property(nonatomic,strong)NSArray *textArray;
/*
 ** 当前显示的角标
 */
@property(nonatomic,assign)NSUInteger textIndex;
/*
 ** 两个切换的背景
 */
@property(nonatomic,strong)UIImageView *deskback1;
@property(nonatomic,strong)UIImageView *deskback2;
/*
 ** 自定义炫酷文本
 */
@property(nonatomic,strong)KSShineLable *shineLable;
@end

@implementation ViewController
/*
 ** 初始参数的赋值
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.textArray=@[@"布医健康竭诚为您服务",@"请按照温馨提示按时进行每天的身体健康指标的测量，包括血压，血糖，心率，体重和体温",@"血压测量结果不错哦继续加油，早晚进食适量应继续保持"];
        _textIndex=0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     ** 奇葩的赋值方式
     */
    self.deskback1=({
        UIImageView *ima=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p1@2x"]];
        ima.contentMode=UIViewContentModeScaleAspectFill;
        ima.frame=self.view.bounds;
        ima;
    });
    [self.view addSubview:self.deskback1];
    self.deskback2=({
        UIImageView *ima=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p2@2x"]];
        ima.contentMode=UIViewContentModeScaleAspectFill;
        ima.frame=self.view.bounds;
        //第二个透明
        ima.alpha=0;
        ima;
    });
    [self.view addSubview:self.deskback2];
    
    self.shineLable = ({
        KSShineLable *label = [[KSShineLable alloc] initWithFrame:CGRectMake(20, 20, [[UIScreen mainScreen] bounds].size.width-40, 200)];
        label.numberOfLines = 0;
        label.text = [self.textArray objectAtIndex:self.textIndex];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self.view addSubview:self.shineLable];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLable shine];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.shineLable.isVisible) {
        [self.shineLable fadeOutWithCompletion:^{
            [self changeText];
            [UIView animateWithDuration:2.5 animations:^{
                if (self.deskback1.alpha > 0.1) {
                    self.deskback1.alpha = 0;
                    self.deskback2.alpha = 1;
                }
                else {
                    self.deskback1.alpha = 1;
                    self.deskback2.alpha = 0;
                }
            }];
            [self.shineLable shine];
        }];
    }
    else {
        [self.shineLable shine];
    }
}

- (void)changeText
{
    self.shineLable.text = self.textArray[(++self.textIndex) % self.textArray.count];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
