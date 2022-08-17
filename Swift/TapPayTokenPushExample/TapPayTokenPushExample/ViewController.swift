//
//  ViewController.swift
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/11.
//

import UIKit

private let ACCOUNT = "Test"
private let PASSWORD = "Test"

class ViewController: BaseViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    var queryItems : Array<URLQueryItem> = Array.init()
    var token : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(tokenGet(notification:)), name: NSNotification.Name.init("TSP_Push_Token"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setIndicatorHidden(hidden: true)
    }

    @objc func tokenGet(notification : NSNotification) {
        
        queryItems = notification.object as! Array<URLQueryItem>
        token = queryItems.filter({$0.name == "tspPushToken"}).first?.value ?? ""
        if token.count > 0 {
            DispatchQueue.main.async {
                self.setIndicatorHidden(hidden: true)
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    self.setIndicatorHidden(hidden: false)
                    self.performSegue(withIdentifier: "LoginToTokenPush", sender: nil)
                }
            }
        }
    }
    
    private func isLoginValid() -> Bool {
        if accountTextField.text?.count ?? 0 <= 0 ||
            passwordTextField.text?.count ?? 0 <= 0 ||
            accountTextField.text != ACCOUNT ||
            passwordTextField.text != PASSWORD {
            return false
        }
        return true
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        if isLoginValid() {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginToTokenPush", sender: nil)
            }
        }else {
            let controller = UIAlertController.init(title: "Error", message: "Login Failed", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default)
            controller.addAction(okAction)
            self.present(controller, animated: false)
        }
    }
    
    @IBAction func accountChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            loginBtn.isEnabled = (textField.text?.count ?? 0 > 0)
        }
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            loginBtn.isEnabled = (textField.text?.count ?? 0 > 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToTokenPush" {
            if let controller = segue.destination as? TokenPushViewController {
                controller.token = token
                controller.cancelUrl = queryItems.filter({$0.name == "cancelUrl"}).first?.value ?? ""
            }
        }
    }
    
}

