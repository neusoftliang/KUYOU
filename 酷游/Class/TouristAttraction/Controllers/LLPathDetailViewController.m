//
//  LLPathDetailViewController.m
//  酷游
//
//  Created by tarena on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLPathDetailViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import <WebKit/WebKit.h>
@interface LLPathDetailViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIToolbar *toolBar ;
@property (nonatomic,strong) NSURLRequest *request;
@end

@implementation LLPathDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.hidden = NO;
    self.toolBar.hidden = NO;
    NSLog(@"url%@",self.pathModel.detail);
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    [self connNet];
}
-(void)connNet
{
    __weak LLPathDetailViewController *weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.pathModel.detail parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *urlStr = responseObject[@"result"][@"url"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [weakSelf.webView loadRequest:request];
        NSLog(@"urlStr%@",urlStr);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}

#pragma mark --- WKNavigationDelegate
//开始加载网页
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //设置状态条(status bar)的activityIndicatorView开始动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

//成功加载完毕
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //设置indicatorView动画停止
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    //停止动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"加载失败:%@", webView);
    
}


#pragma mark --- toolBar 设置

- (UIToolbar *)toolBar  {
    if(_toolBar  == nil)
    {
        _toolBar  = [[UIToolbar alloc] init];
        [self.view addSubview:_toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(rebackLastPage)];
        UIBarButtonItem *refreshBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshLoad)];
        UIBarButtonItem *stopBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"停止" style:UIBarButtonItemStylePlain target:self action:@selector(stopLoad)];
        UIBarButtonItem *fixSpaceA = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        UIBarButtonItem *fixSpaceB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        UIBarButtonItem *flexibleSpaceA = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexibleSpaceB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:fixSpaceA];
        [items addObject:backBtnItem];
        [items addObject:flexibleSpaceA];
        [items addObject:refreshBtnItem];
        [items addObject:flexibleSpaceB];
        [items addObject:stopBtnItem];
        [items addObject:fixSpaceB];
        [_toolBar setItems:items];
    }
    return _toolBar ;
}
/**
 *  返回上一个界面
 */
-(void)rebackLastPage
{
    [self stopLoad];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  刷新当前窗口
 */
-(void)refreshLoad
{
    //[self connNet];
    [self.webView reload];
}
/**
 *  停止加载web请求
 */
-(void)stopLoad
{
    [self.webView stopLoading];
}

@end
