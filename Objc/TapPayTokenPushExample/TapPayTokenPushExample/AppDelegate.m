//
//  AppDelegate.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import "AppDelegate.h"
#import "GlobalFunction.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
    if (url) {
        NSArray *queryItems = [GlobalFunction queryParameter:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TSP_Push_Token" object:queryItems];
        });
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if (self.window.rootViewController.childViewControllers > 0) {
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                [navigationController popToRootViewControllerAnimated:false];
                NSURL * url = userActivity.webpageURL;
                NSArray *queryItems = [GlobalFunction queryParameter:url];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TSP_Push_Token" object:queryItems];
            });
        }
    }
    return true;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (self.window.rootViewController.childViewControllers > 0) {
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                [navigationController popToRootViewControllerAnimated:false];
                NSArray *queryItems = [GlobalFunction queryParameter:url];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TSP_Push_Token" object:queryItems];
            });
        }
    }
    return true;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
