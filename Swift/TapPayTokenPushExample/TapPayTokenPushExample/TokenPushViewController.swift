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
    var pushToken : String = ""
    var cancelUrl : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(tokenGet(notification:)), name: NSNotification.Name.init("TSP_Push_Token"), object: nil)
        if pushToken.count > 0 {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func tokenGet(notification : NSNotification) {
        if pushToken.count <= 0 {
            let queryItems = notification.object as! Array<URLQueryItem>
            let token = queryItems.filter({$0.name == "tspPushToken"}).first?.value ?? ""
            if token.count > 0 {
                pushToken = token
                doPushTokenize()
            }
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
            cardNumberLabel.text = "\(resultDict ?? Dictionary.init())"
        case .cancel:
            statusImageView.image = UIImage.init(named: "success")
            resultLabel.text = "Cancel Success"
            cardNumberLabel.isHidden = true
            cardNumberLabel.text = ""
        default:
            break
        }
        
        let callbackUrl = resultDict!["callback_url"] as? String ?? ""
        if callbackUrl.count <= 0 && cancelUrl.count <= 0 {
            backToBankBtn.isHidden = true
            btnGoShoppingTrailingLC.constant = (self.view.bounds.width - backToBankBtn.frame.width)/2
        }else {
            backToBankBtn.isHidden = false
            btnGoShoppingTrailingLC.constant = DEFAULT_TRAILING
        }
    }
    
    @IBAction func backToBankPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let url = (self.bindStatus == .cancel) ? URL.init(string: self.cancelUrl)! : URL.init(string: self.resultDict!["callback_url"] as! String)!
            UIApplication.shared.open(url)
        }
    }
    
    private func pushTokenizeWithToken(token: String ,success: @escaping (_ result: Dictionary<String, Any>) -> Void ,fail: @escaping (_ result:Dictionary<String, Any>?, _ error:Error?) -> Void) {
        
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
                    
                    let status = dic["status"] as! Int
                    if status == 0 || status == 19004 {
                        success(dic)
                    }else {
                        fail(dic, nil)
                    }
                } catch  {
                    print(error)
                    fail(nil, error)
                }
            }
        }.resume()
    }
    
    private func doPushTokenize() {
        setIndicatorHidden(hidden: false)
        pushTokenizeWithToken(token: pushToken) { result in
            self.pushToken = ""
            self.bindStatus = .success
            self.resultDict = result
            DispatchQueue.main.async {
                self.setIndicatorHidden(hidden: true)
                self.configResultUIWithStatus(status: .success)
            }
        } fail: {result,error in
            self.pushToken = ""
            self.bindStatus = .fail
            self.resultDict = result
            DispatchQueue.main.async {
                self.setIndicatorHidden(hidden: true)
                self.configResultUIWithStatus(status: .fail)
            }
        }
    }
}

extension TokenPushViewController: TermsViewControllerDelegate {
    
    func didFinishReadingTerms(controller: TermsViewController) {
        doPushTokenize()
    }
    
    func didCancelReadingTerms(controller: TermsViewController) {
        self.pushToken = ""
        self.bindStatus = .cancel
        configResultUIWithStatus(status: .cancel)
    }
}
