//
//  TermsViewController.h
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TermsViewControllerDelegate;

@interface TermsViewController : UIViewController

@property(retain, nonatomic) id<TermsViewControllerDelegate> delegate;

@end

@protocol TermsViewControllerDelegate <NSObject>

- (void)didFinishReadingTerms:(TermsViewController *)controller;
- (void)didCancelReadingTerms:(TermsViewController *)controller;

@end

NS_ASSUME_NONNULL_END
