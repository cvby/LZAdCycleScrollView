//
//  UIImageView+CBDWebImage.h
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage/YYWebImage.h>
#import "CBDProgressView.h"

/** Loading样式
 */
typedef enum{
    enumLoadActivityIndicator,  //菊花
    enumLoadProgressLine,       //进度直线
    enumLoadNone                //无
} enumLoadingType;

@interface UIImageView (CBDWebImage)

@property (nullable, nonatomic, strong) NSString *cbd_imageURL;

/**
 @param 附加上的控件
 */
@property (nullable, nonatomic, strong,getter=activity) UIActivityIndicatorView *activity;
@property (nullable, nonatomic, strong) CBDProgressView *progressView;
/**
 @param loadType    展示类型
 */
@property (nonatomic, assign) enumLoadingType loadType;


- (void)cbd_setImageWithURL:(nullable NSString *)imageURL
                placeholder:(nullable NSString *)placeholder
                 completion:(nullable YYWebImageCompletionBlock)completion;

- (void)cbd_setImageWithURL:(nullable NSString *)imageURL
                placeholder:(nullable NSString *)placeholder
                  failImage:(nullable NSString *)failImage
                 completion:(nullable YYWebImageCompletionBlock)completion;

- (void)cbd_setImageWithURL:(nullable NSString *)imageURL
                placeholder:(nullable NSString *)placeholder
                  failImage:(nullable NSString *)failImage
                    options:(YYWebImageOptions)options
                   progress:(nullable YYWebImageProgressBlock)progress
                 completion:(nullable YYWebImageCompletionBlock)completion;
@end
