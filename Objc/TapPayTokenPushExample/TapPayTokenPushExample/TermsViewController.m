//
//  TermsViewController.m
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/10.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@property (weak, nonatomic) IBOutlet UIView *termsView;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImageView;
@property (assign, nonatomic) BOOL isChecked;

@end

@implementation TermsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTermsViewWithCheckStatus:_isChecked];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsViewTouched)];
    [_termsView addGestureRecognizer:tapGesture];
}

#pragma mark - Private Method

- (void)termsViewTouched {
    _isChecked = !_isChecked;
    [self configTermsViewWithCheckStatus:_isChecked];
}

- (void)configTermsViewWithCheckStatus:(BOOL)isCheked {
    if (isCheked) {
        [_checkboxImageView setImage:[UIImage systemImageNamed:@"checkmark.square"]];
        [_agreeBtn setEnabled:true];
    }else {
        [_checkboxImageView setImage:[UIImage systemImageNamed:@"square"]];
        [_agreeBtn setEnabled:false];
    }
}

#pragma mark - IBAction

- (IBAction)disagreePressed:(id)sender {
    [self dismissViewControllerAnimated:false completion:^{
        if ([self.delegate respondsToSelector:@selector(didCancelReadingTerms:)]) {
            [self.delegate didCancelReadingTerms:self];
        }
    }];
}

- (IBAction)agreePressed:(id)sender {
    [self dismissViewControllerAnimated:false completion:^{
        if ([self.delegate respondsToSelector:@selector(didFinishReadingTerms:)]) {
            [self.delegate didFinishReadingTerms:self];
        }
    }];
}


@end
