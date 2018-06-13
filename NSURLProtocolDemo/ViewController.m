//
//  ViewController.m
//  NSURLProtocolDemo
//
//  Created by JackXu on 2018/6/13.
//  Copyright © 2018年 JackXu. All rights reserved.
//

#import "ViewController.h"
#import "JXURLProtocol.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSURLProtocol registerClass:[JXURLProtocol class]];

    [self loadWeb];
}


- (void)loadWeb {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
