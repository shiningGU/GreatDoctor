//
//  shfz_AFNetworking.h
//  shfz
//
//  Created by shanghaifuzhong on 15/8/13.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface shfz_AFNetworking : AFHTTPRequestOperationManager
//检测网络状态
+ (void)netWorkStatus;
//JSON方式获取数据
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail;
//xml方式获取数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail;
//post提交json数据
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail;
//下载文件
//+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;
//文件上传－自定义上传文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;
//文件上传－随机生成文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail;

@end
