# Tappay-iOS-Tokenpush-Example

TapPay Push Token Example Code for iOS Plateform.

- <font size=1> [Flow](#flow) </font>
- <font size=1> [Prepare](#prepare) </font>
- <font size=1> [Usage](#usage) </font>

<a name="flow"></a>
# Flow
![](./TSP_Shop_Bind_Card_Flow.png)


<a name="prepare"></a>
# Prepare

Get push token from the website which provide by mastercard
(Please conteact TapPay for TRID)
> https://tokenconnect.mcsrcteststore.com/dashboard

<a name="usage"></a>
# Usage

### If the setup and usage of issuer bank app has already finished

### Objective c
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

### 2. Register observer to get push token and post push tokenize request

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenGet:) name:@"TSP_Push_Token" object:nil];
}

- (void)tokenGet:(NSNotification *)notification {
    NSString *pushToken = [notification object];
    if (pushToken.length > 0) {
        [self pushTokenizeWithToken:pushToken successCallback:^(PushTokenizeObject *result) {
            // Do something here if request succeed
        } failureCallback:^(NSInteger status, NSString *message) {
            // Do something here if request failed
        }];
    }
}

- (void)pushTokenizeWithToken:(NSString *)token
              successCallback:(void (^ _Nullable)(PushTokenizeObject *result))successCallback
              failureCallback:(void (^ _Nullable)(NSInteger status, NSString * message))failureCallback{
    
}
```

### Swift
