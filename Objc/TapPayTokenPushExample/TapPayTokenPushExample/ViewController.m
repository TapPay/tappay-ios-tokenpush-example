//
//  ViewController.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import "ViewController.h"
#import "TokenPushViewController.h"
#import "GlobalFunction.h"

#define ACCOUNT @"Test"
#define PASSWORD @"Test"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) NSArray *queryItems;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit:)];
    [self.view addGestureRecognizer:tapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenGet:) name:@"TSP_Push_Token" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setIndicatorHidden:true];
    });
}

#pragma mark - Private Method

- (void)endEdit:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:true];
}

- (void)tokenGet:(NSNotification *)notification {
    NSArray *queryItems = [notification object];
    _queryItems = queryItems;
    if ([[GlobalFunction valueForKey:@"tspPushToken" fromQueryItems:_queryItems] length] > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setIndicatorHidden:false];
            [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:false block:^(NSTimer * _Nonnull timer) {
                [self setIndicatorHidden:true];
                [self performSegueWithIdentifier:@"LoginToTokenPush" sender:nil];
            }];
        });
    }
}

- (BOOL)isLoginValid {
    if (_accountTextField.text.length <= 0 ||
        _passwordTextField.text.length <= 0 ||
        ![_accountTextField.text isEqualToString:ACCOUNT] ||
        ![_passwordTextField.text isEqualToString:PASSWORD]) {
        return false;
    }
    return true;
}

#pragma mark - IBAction

- (IBAction)loginPressed:(id)sender {
    if ([self isLoginValid]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"LoginToTokenPush" sender:nil];
        });
    }else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Login Failed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:okAction];
        [self presentViewController:controller animated:false completion:nil];
    }
}

- (IBAction)accountChanged:(id)sender {
    UITextField *textField = (UITextField *)sender;
    [_loginBtn setEnabled:(textField.text.length > 0)];
}

- (IBAction)passwordChanged:(id)sender {
    UITextField *textField = (UITextField *)sender;
    [_loginBtn setEnabled:(textField.text.length > 0)];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginToTokenPush"]) {
        TokenPushViewController *controller = segue.destinationViewController;
        controller.token = [GlobalFunction valueForKey:@"tspPushToken" fromQueryItems:_queryItems];
        controller.cancelUrl = [GlobalFunction valueForKey:@"cancelUrl" fromQueryItems:_queryItems];
    }
}

@end
