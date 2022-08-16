//
//  BaseViewController.swift
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/12.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    var indicatorBackgroundView : UIView?
    var loadingIndicator : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIndicator()
    }
    
    private func initIndicator() {
        loadingIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        loadingIndicator?.center = self.view.center
        
        indicatorBackgroundView = UIView.init(frame: self.view.bounds)
        indicatorBackgroundView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        indicatorBackgroundView?.addSubview(loadingIndicator!)
        self.view.addSubview(indicatorBackgroundView!)
        
        indicatorBackgroundView?.isHidden = true
    }
    
    func setIndicatorHidden(hidden: Bool) {
        DispatchQueue.main.async {
            if !hidden {
                self.indicatorBackgroundView?.isHidden = false
                self.loadingIndicator?.startAnimating()
            }else {
                self.indicatorBackgroundView?.isHidden = true
                self.loadingIndicator?.stopAnimating()
            }
        }
    }
}
