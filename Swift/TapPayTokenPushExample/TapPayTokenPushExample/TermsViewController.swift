//
//  TermsViewController.swift
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/12.
//

import Foundation
import UIKit

protocol TermsViewControllerDelegate: NSObjectProtocol {
    func didFinishReadingTerms(controller: TermsViewController)
    func didCancelReadingTerms(controller: TermsViewController)
}

class TermsViewController: BaseViewController {
    
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var disagreeBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var checkboxImageView: UIImageView!
    var isChecked: Bool = false
    var delegate: TermsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTermsViewWithCheckStatus(isChecked: isChecked)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(termsViewTouched))
        termsView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func termsViewTouched() {
        isChecked = !isChecked
        configTermsViewWithCheckStatus(isChecked: isChecked)
    }
    
    private func configTermsViewWithCheckStatus(isChecked: Bool) {
        if isChecked {
            checkboxImageView.image = UIImage.init(systemName: "checkmark.square")
            agreeBtn.isEnabled = true
        }else {
            checkboxImageView.image = UIImage.init(systemName: "square")
            agreeBtn.isEnabled = false
        }
    }
    
    @IBAction func disagreePressed(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.didCancelReadingTerms(controller: self)
        }
    }
    
    @IBAction func agreePressed(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.didFinishReadingTerms(controller: self)
        }
    }
}
