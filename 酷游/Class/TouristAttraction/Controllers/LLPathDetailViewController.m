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
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface LLPathDetailViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIToolbar *toolBar ;
@property (nonatomic,strong) NSURLRequest *request;
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation LLPathDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.hidden = NO;
    self.toolBar.hidden = NO;
    NSLog(@"url%@",self.pathModel.detail);
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self setProgress];
    [self connNet];
}
/**
 *  监听方法的实现
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object ==_webView)
    {
        if ([keyPath isEqualToString:@"estimatedProgress"])
        {
            [self.progressView setAlpha:1.0];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if (self.webView.estimatedProgress>=1.0)
            {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        
    }
}
/**
 *  配置进度条
 */
-(void)setProgress
{
    CGRect navBounds = self.toolBar.frame;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 44,
                                 navBounds.size.width,
                                 2);
    _progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0 animated:YES];
    [self.toolBar addSubview:_progressView];
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
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
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
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView stopLoading];
}
@end
