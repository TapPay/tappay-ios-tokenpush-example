# tappay-ios-tokenpush-example

TapPay Push Token Example Code for iOS Plateform.

# Prepare

Get push token from the website which provide by mastercard
> https://tokenconnect.mcsrcteststore.com/dashboard

# Usage

### If the setup and usage of issuer bank app has already finished
### 1. Get push token in AppDelegate or SceneDelegate
```objc
// AppDelegate
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // Parsing the url by any method which could return parameters
    NSDictionary *parseResult = [GlobalFunction queryParameter:url];
    NSString *pushToken = [parseResult objectForKey:@"tspPushToken"];
    // Post the push token to observer
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TSP_Push_Token" object:pushToken];
    return true;
}
```
```objc
// SceneDelegate
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    NSURL * url = [[[URLContexts allObjects] firstObject] URL];
    // Parsing the url by any method which could return parameters
    NSDictionary *parseResult = [GlobalFunction queryParameter:url];
    NSString *pushToken = [parseResult objectForKey:@"tspPushToken"];
    // Post the push token to observer
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TSP_Push_Token" object:pushToken];
}
```
