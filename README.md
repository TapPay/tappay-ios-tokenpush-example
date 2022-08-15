# Tappay-iOS-Tokenpush-Example

TapPay Push Token Example Code for iOS Plateform.

- <font size=1> [Flow](#flow) </font>
- <font size=1> [Prepare](#prepare) </font>
- <font size=1> [Usage - Objective C](#usage-objc) </font>
- <font size=1> [Usage - Swift](#usage-swift) </font>

<a name="flow"></a>
# Flow
![](./TSP_Shop_Bind_Card_Flow.png)


<a name="prepare"></a>
# Prepare

Get push token from the website which provide by mastercard
(Please contact TapPay for TRID and access code)
> https://tokenconnect.mcsrcteststore.com/dashboard

# Usage

### If the setup and usage of issuer bank app has already finished

<a name="usage-objc"></a>
### Objective C
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
              successCallback:(void (^)(NSDictionary *result))successCallback
              failureCallback:(void (^)(NSInteger status, NSString * message))failureCallback{
    
}
```

<a name="usage-swift"></a>
### Swift

### 1. Get push token in AppDelegate or SceneDelegate
```swift
// AppDelegate
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Parsing the url by any method which could return parameters
    let parseResult = Global.queryParameter(url: url)
    let pushToken = parseResult["tspPushToken"]
    // Post the push token to observer
    NotificationCenter.default.post(name: NSNotification.Name.init("TSP_Push_Token"), object: pushToken, userInfo: nil)
    return true
}
```
```swift
// SceneDelegate
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
        // Parsing the url by any method which could return parameters
        let parseResult = Global.queryParameter(url: url)
        let pushToken = parseResult["tspPushToken"]
        // Post the push token to observer
        NotificationCenter.default.post(name: NSNotification.Name.init("TSP_Push_Token"), object: pushToken, userInfo: nil)
    }
}
```

### 2. Register observer to get push token and post push tokenize request

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    NotificationCenter.default.addObserver(self, selector: #selector(tokenGet(notification:)), name: NSNotification.Name.init("TSP_Push_Token"), object: nil)
}

@objc func tokenGet(notification : NSNotification) {
    let pushToken = notification.object as! String
    if pushToken.count > 0 {
        pushTokenizeWithToken(token: pushToken) { result in
            // Do something here if request succeed
        } fail: {
            // Do something here if request failed
        }
    }
}

private func pushTokenizeWithToken(token: String ,success: @escaping (_ result: Dictionary<String, Any>) -> Void ,fail: @escaping () -> Void) {
    
}
```
