//
//  GlobalFunction.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import "GlobalFunction.h"

@implementation GlobalFunction

+ (NSMutableDictionary *)queryParameter:(NSURL *)url {
    
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    
    for (NSString *qs in [url.query componentsSeparatedByString:@"&"]) {
        // Get the parameter name
        NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
        // Get the parameter value
        NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        value = [value stringByRemovingPercentEncoding];
        
        queryStrings[key] = value;
        
    }
    
    return queryStrings;
    
}

@end
