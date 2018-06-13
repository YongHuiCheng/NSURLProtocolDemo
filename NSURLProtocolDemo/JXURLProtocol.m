//
//  JXURLProtocol.m
//  NSURLProtocolDemo
//
//  Created by JackXu on 2018/6/13.
//  Copyright © 2018年 JackXu. All rights reserved.
//

#import "JXURLProtocol.h"

@implementation JXURLProtocol

//所有请求
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"%@",urlString);
    
    if ([NSURLProtocol propertyForKey:@"JXProtocol" inRequest:request]) {
        return NO;
    }
    
    if ([urlString isEqualToString:@"https://m.baidu.com/static/index/plus/plus_logo.png"]) {
        return YES;
    }
    return NO;
}


- (void)startLoading{
    NSData *imageData = [self imageDataWithUrl:self.request.URL];
    if (imageData) {
        //构建请求头
        NSString *mimeType = @"image/jpeg";
        
        NSMutableDictionary *header = [NSMutableDictionary dictionary];
        
        NSString *contentType = [mimeType stringByAppendingString:@";chartset=UTF-8"];
        header[@"Content-type"] = contentType;
        header[@"Content-Length"] = [NSString stringWithFormat:@"%ld",imageData.length];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                                  statusCode:200 HTTPVersion:@"1.1" headerFields:header];
        //回调
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
        [self.client URLProtocol:self didLoadData:imageData];
        [self.client URLProtocolDidFinishLoading:self];
    }else{
        [NSURLProtocol setProperty:@(YES) forKey:@"JXProtocol" inRequest:self.request];
        NSMutableURLRequest *newRequset = [self.request mutableCopy];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionTask *task = [session dataTaskWithRequest:newRequset];
        [task resume];
    }
}

- (NSData*)imageDataWithUrl:(NSURL*)url{
    if ([url.absoluteString isEqualToString:@"https://m.baidu.com/static/index/plus/plus_logo.png"]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"long" ofType:@"png"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return data;
    }
    return nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)stopLoading{
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

@end
