//
//  BaseViewController.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/10.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIView *indicatorBackgroundView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

@end

@implementation BaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initIndicator];
}

#pragma mark - Private Method

- (void)initIndicator {
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    _loadingIndicator.center = self.view.center;
    
    _indicatorBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_indicatorBackgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [_indicatorBackgroundView addSubview:_loadingIndicator];
    [self.view addSubview:_indicatorBackgroundView];
    
    [_indicatorBackgroundView setHidden:true];
}

#pragma mark - Public Method

- (void)setIndicatorHidden:(BOOL)hidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!hidden) {
            [self.indicatorBackgroundView setHidden:false];
            [self.loadingIndicator startAnimating];
        }else {
            [self.indicatorBackgroundView setHidden:true];
            [self.loadingIndicator stopAnimating];
        }
    });
}

@end
