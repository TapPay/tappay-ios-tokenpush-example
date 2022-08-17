//
//  TokenPushViewController.h
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/9.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TokenPushViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *cancelUrl;

@end

NS_ASSUME_NONNULL_END
