//
//  TokenPushViewController.swift
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/12.
//

import Foundation
import UIKit

private let DEFAULT_TRAILING = 59.0
private let PUSH_TOKENIZE_PATH = "https://prod-main.dev.tappaysdk.com/tpc/tsp/token/push-tokenize"
private let PUSH_TOKENIZE_ACCESS_KEY = "72DMgo9RQN2BSW4SmaHWYVOUCEIUDMg9i1JnXKic"

enum BindStatus {
    case success
    case fail
    case cancel
}

class TokenPushViewController : BaseViewController{
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var btnGoShoppingTrailingLC: NSLayoutConstraint!
    @IBOutlet weak var backToBankBtn: UIButton!
    private var bindStatus: BindStatus?
    private var resultDict : Dictionary<String, Any>?
    var token : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if token.count > 0 {
            let termsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            termsViewController.delegate = self
            termsViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            DispatchQueue.main.async {
                self.present(termsViewController, animated: false)
            }
        }else {
            configResultUIWithStatus(status: .cancel)
        }
    }
    
    private func configResultUIWithStatus(status: BindStatus) {
        switch status {
        case .success:
            statusImageView.image = UIImage.init(named: "success")
            resultLabel.text = "Add Card Success"
            cardNumberLabel.isHidden = false
            cardNumberLabel.text = "\(resultDict ?? Dictionary.init())"
        case .fail:
            statusImageView.image = UIImage.init(named: "failed")
            resultLabel.text = "Add Card Fail"
            cardNumberLabel.isHidden = true
            cardNumberLabel.text = ""
        case .cancel:
            statusImageView.image = UIImage.init(named: "success")
            resultLabel.text = "Cancel Success"
            cardNumberLabel.isHidden = true
            cardNumberLabel.text = ""
        default:
            break
        }
        
        if token.count <= 0 {
            backToBankBtn.isHidden = true
            btnGoShoppingTrailingLC.constant = (self.view.bounds.width - backToBankBtn.frame.width)/2
        }else {
            backToBankBtn.isHidden = false
            btnGoShoppingTrailingLC.constant = DEFAULT_TRAILING
        }
    }
    
    @IBAction func backToBankPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let url = URL.init(string: self.resultDict!["callback_url"] as! String)!
            UIApplication.shared.open(url)
        }
    }
    
    private func pushTokenizeWithToken(token: String ,success: @escaping (_ result: Dictionary<String, Any>) -> Void ,fail: @escaping () -> Void) {
        
        let url = URL.init(string: PUSH_TOKENIZE_PATH)!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(PUSH_TOKENIZE_ACCESS_KEY, forHTTPHeaderField: "x-api-key")
        
        let encoder = JSONEncoder()
        let parametersDict = ["partner_key":PUSH_TOKENIZE_ACCESS_KEY,"tsp_push_token":token]
        let data = try? encoder.encode(parametersDict)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    let dic = json as! Dictionary<String,Any>
                    print(dic)
                    success(dic)
                } catch  {
                    print(error)
                }
            }
        }.resume()
    }
}

extension TokenPushViewController: TermsViewControllerDelegate {
    
    func didFinishReadingTerms(controller: TermsViewController) {
        setIndicatorHidden(hidden: false)
        pushTokenizeWithToken(token: token) { result in
            self.resultDict = result
            DispatchQueue.main.async {
                self.setIndicatorHidden(hidden: true)
                self.configResultUIWithStatus(status: .success)
            }
        } fail: {
            DispatchQueue.main.async {
                self.setIndicatorHidden(hidden: true)
                self.configResultUIWithStatus(status: .fail)
            }
        }
    }
    
    func didCancelReadingTerms(controller: TermsViewController) {
        configResultUIWithStatus(status: .cancel)
    }
}
