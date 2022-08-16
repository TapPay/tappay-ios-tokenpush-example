//
//  TokenPushViewController.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import "TokenPushViewController.h"
#import "TermsViewController.h"
#import "GlobalFunction.h"

#define DEFAULT_TRAILING 59.0
#define PUSH_TOKENIZE_PATH @"https://prod-main.dev.tappaysdk.com/tpc/tsp/token/push-tokenize"
#define PUSH_TOKENIZE_ACCESS_KEY @"72DMgo9RQN2BSW4SmaHWYVOUCEIUDMg9i1JnXKic"

typedef NS_ENUM(NSInteger, BindStatus) {
    BindStatusSuccess,
    BindStatusFail,
    BindStatusCancel
};

@interface TokenPushViewController ()<TermsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (assign, nonatomic) BindStatus bindStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnGoShoppingTrailingLC;
@property (weak, nonatomic) IBOutlet UIButton *backToBankBtn;
@property (strong, nonatomic) NSDictionary *resultDict;

@end

@implementation TokenPushViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_token.length > 0) {
        TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        termsViewController.delegate = self;
        termsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:termsViewController animated:false completion:nil];
        });
    }else {
        [self configResultUIWithStatus:BindStatusCancel];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // For test (will be removed before release)
    if (_token.length > 0) {
//        [self notifyToken];
    }
}

#pragma mark - Private Method

- (void)configResultUIWithStatus:(BindStatus)status {
    switch (status) {
        case BindStatusSuccess:
        {
            [_statusImageView setImage:[UIImage imageNamed:@"success"]];
            [_resultLabel setText:@"Add Card Success"];
            [_cardNumberLabel setHidden:false];
            [_cardNumberLabel setText:[NSString stringWithFormat:@"%@", _resultDict]];
        }
            break;
        case BindStatusFail:
        {
            [_statusImageView setImage:[UIImage imageNamed:@"failed"]];
            [_resultLabel setText:@"Add Card Fail"];
            [_cardNumberLabel setHidden:false];
            [_cardNumberLabel setText:[NSString stringWithFormat:@"%@", _resultDict]];
        }
            break;
        case BindStatusCancel:
        {
            [_statusImageView setImage:[UIImage imageNamed:@"success"]];
            [_resultLabel setText:@"Cancel Success"];
            [_cardNumberLabel setHidden:true];
            [_cardNumberLabel setText:@""];
        }
            break;
        default:
            break;
    }
    
    if (_token.length <= 0) {
        [_backToBankBtn setHidden:true];
        _btnGoShoppingTrailingLC.constant = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_backToBankBtn.frame))/2;
    }else {
        [_backToBankBtn setHidden:false];
        _btnGoShoppingTrailingLC.constant = DEFAULT_TRAILING;
    }
}

#pragma mark - IBAction

- (IBAction)backToBankPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:[self.resultDict objectForKey:@"callback_url"]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    });
}

#pragma mark - Push Tokenize API

// For test (will be removed before release)
- (void)notifyToken {
    NSURL *url = [NSURL URLWithString:@"https://pushtoken.requestcatcher.com/test"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSDictionary *parametersDict = @{@"tsp_push_token":_token};
    NSData *parameterData =[NSJSONSerialization dataWithJSONObject:parametersDict options:NSJSONWritingPrettyPrinted error:NULL];
    [request setHTTPBody:parameterData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }] resume];
}

- (void)pushTokenizeWithToken:(NSString *)token
              successCallback:(void (^)(NSDictionary *result))successCallback
              failureCallback:(void (^)(NSInteger status, NSString * message))failureCallback{
    
    NSURL *url = [NSURL URLWithString:PUSH_TOKENIZE_PATH];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:PUSH_TOKENIZE_ACCESS_KEY forHTTPHeaderField:@"x-api-key"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSDictionary *parametersDict = @{@"partner_key":PUSH_TOKENIZE_ACCESS_KEY,
                                     @"tsp_push_token":token};
    NSData *parameterData =[NSJSONSerialization dataWithJSONObject:parametersDict options:NSJSONWritingPrettyPrinted error:NULL];
    [request setHTTPBody:parameterData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *JsonObject = (data != nil) ?[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] : nil;
        NSLog(@"%@", JsonObject);
        if ([[JsonObject objectForKey:@"status"] integerValue] == 0) {
            if (successCallback) {
                successCallback(JsonObject);
            }
        }else {
            if (failureCallback) {
                failureCallback([[JsonObject objectForKey:@"status"] integerValue], [JsonObject objectForKey:@"msg"]);
            }
        }
        
    }] resume];
}

#pragma mark - TermsViewController Delegate

- (void)didFinishReadingTerms:(TermsViewController *)controller {
    [self setIndicatorHidden:false];
    [self pushTokenizeWithToken:_token successCallback:^(NSDictionary *result) {
        self.resultDict = [NSDictionary dictionary];
        self.resultDict = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setIndicatorHidden:true];
            [self configResultUIWithStatus:BindStatusSuccess];
        });
    } failureCallback:^(NSInteger status, NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setIndicatorHidden:true];
            [self configResultUIWithStatus:BindStatusFail];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:okAction];
            [self presentViewController:controller animated:false completion:nil];
        });
    }];
}

- (void)didCancelReadingTerms:(TermsViewController *)controller {
    [self configResultUIWithStatus:BindStatusCancel];
}

@end
