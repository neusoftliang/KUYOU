//
//  WelcomeViewController.m
//  demo2_contentSize欢迎界面
//
//  Created by tarena on 15/10/16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LWDTabBarController.h"
#import "LLPopTableViewController.h"
@interface WelcomeViewController ()<UIScrollViewDelegate>//*************************************************22222
@property(nonatomic,strong)UIPageControl* pc;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //配置滚动视图
    [self setUpScrollView];
    //配置分页界面
    [self setUpPageController];
    
}
 //配置滚动视图
-(void)setUpScrollView
{
    //1创建滚动视图
    UIScrollView* sv=[[UIScrollView alloc]init];
    //2设置可见区域=view的
    sv.frame=self.view.bounds;
    //设置滚动视图的代理为当前控制器*******************************************************************************11111
    //代理就负责响应滚动视图发出的各种消息
    sv.delegate=self;
    
    
    
    //2.1想滚动视图中添加多个子视图
    for(int i=0;i<5;i++)
    {
        //格式化出图片名称
        NSString* imageName=[NSString stringWithFormat:@"%d.jpg",i+1];
       //2.11创建一个视图对象
        UIImageView* iv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        //2.12设置图片视图的位置大小
        //声明了一个结构体的变量，其中xywh初始化为0
        CGRect iFrame=CGRectZero;
        iFrame.origin=CGPointMake(i*sv.bounds.size.width, 0);
        iFrame.size=sv.frame.size;//等同于iFrame.size=sv.bounds.size;
        iv.frame=iFrame;
        
        
    //2.2将图片添加到滚动视图
        [sv addSubview:iv];
        if(i==4){
            //向最后一屏中添加按钮
            [self addEnterButton:iv];//************----------------------------*************
        }

    }
    
    
    
    //2.3设置子视图的内容大小
    sv.contentSize=CGSizeMake(5*sv.bounds.size.width, sv.bounds.size.height);
         //配置滚动视图到达边缘不弹跳*********************************************************
         sv.bounces=NO;
        ////配置滚动视图整页跳动
        sv.pagingEnabled=YES;
    
        //配置滚动视图不显示水平滚动条
    
    sv.showsHorizontalScrollIndicator=NO;
    
    //3添加到view
    [self.view addSubview:sv];
    
    
    
    
}
-(void)setUpPageController
{
    //1创建pagecontroller的实例
    UIPageControl* pc=[[UIPageControl alloc]init];
    self.pc=pc;
    //2设置frame
    pc.frame=CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 30);
    //颜色
    //pc.backgroundColor=[UIColor yellowColor];
    //3添加控制器view
    [self.view addSubview:pc];
    //4配置pagecontroller
    pc.numberOfPages=5;
    //5配置提示符颜色
    pc.pageIndicatorTintColor=[UIColor blackColor];
    //6配置选中的提示符的颜色
    pc.currentPageIndicatorTintColor=[UIColor redColor];
    //关闭原点与用户的交互
    pc.userInteractionEnabled=NO;
    
    
    
}

//向图片视图中添加按钮//******************-------------------------*******************
-(void)addEnterButton:(UIImageView*)iv
{
    //0开启图片视图的用户交互功能，否则不能点按钮进入
    iv.userInteractionEnabled=YES;
    
    
    
    //1创建
    UIButton* button=[[UIButton alloc]init];
    //2frame
    button.frame=CGRectMake((iv.bounds.size.width-150)/2, iv.bounds.size.height*0.6, 150, 40);
    //按钮的其他配置
    [button setTitle:@"进入应用" forState:UIControlStateNormal];
    
    
    //3添加到图片视图中
    [iv addSubview:button];
    
    //4
    [button addTarget:self action:@selector(enterApp:) forControlEvents:UIControlEventTouchUpInside];
    
}
/*按钮响应方法*/
-(void)enterApp:(UIButton*)button
{
//   LWDTabBarController * loginViewController = [[LWDTabBarController alloc]init];
//    //获取应用的主window对象，先获取
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;   
////    //更换window的跟视图控制器为mainVC由于welcome不再是window的跟视图控制器了。所以就会被释放，，，但使用present不会被释放
//        window.rootViewController=loginViewController;
    
    //2push
    [self performSegueWithIdentifier:@"enterApp" sender:nil];
}


#pragma - UIScrollViewDelegate 协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView//**************************************************3333333333
{
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    //round函数的作用是四舍五入
    
    int index=round(scrollView.contentOffset.x/self.view.bounds.size.width);
    self.pc.currentPage=index;
    
    
    
}









@end
