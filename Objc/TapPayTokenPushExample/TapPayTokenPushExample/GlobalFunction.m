//
//  GlobalFunction.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import "GlobalFunction.h"

@implementation GlobalFunction

+ (NSArray *)queryParameter:(NSURL *)url {
    NSArray *items = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO].queryItems;
    return items;
    
}

+ (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

@end
