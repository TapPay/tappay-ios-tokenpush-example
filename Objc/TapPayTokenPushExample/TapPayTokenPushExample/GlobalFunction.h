//
//  GlobalFunction.h
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalFunction : NSObject

+ (NSMutableDictionary *)queryParameter:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
