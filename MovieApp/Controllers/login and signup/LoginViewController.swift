//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/7/21.
//

import UIKit
import ShimmerSwift
import FirebaseAuth
import JGProgressHUD


class LoginViewController: UIViewController {
    
    private let snipper = JGProgressHUD(style:  .dark)
    public static var username : String?
    @IBOutlet weak var Logo_lbl: UILabel!
    @IBOutlet weak var Email_txtField: UITextField!
    
    @IBOutlet weak var password_txtField: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Email_txtField.delegate = self
        password_txtField.delegate = self
        
        Email_txtField.layer.cornerRadius = 15
        Email_txtField.layer.borderWidth = 2
        Email_txtField.layer.borderColor = UIColor.systemPink.cgColor
        
        password_txtField.layer.cornerRadius = 15
        password_txtField.layer.borderWidth = 2
        password_txtField.layer.borderColor = UIColor.systemPink.cgColor
        
        login_btn.layer.cornerRadius = 15
        
//        //login Shimmer View
//        let LoginShimmerView = ShimmeringView(frame: login_btn.bounds)
//        view.addSubview(LoginShimmerView)
//        LoginShimmerView.center = login_btn.center
//        LoginShimmerView.contentView = login_btn
//        //logo Shimmer View
//        let logoShimmerView = ShimmeringView(frame: Logo_lbl.bounds)
//        view.addSubview(logoShimmerView)
//        logoShimmerView.center = Logo_lbl.center
//        logoShimmerView.contentView = Logo_lbl
//        //start or stop annimation
//        LoginShimmerView.shimmerSpeed = 400
//        LoginShimmerView.isShimmering = true
//        logoShimmerView.shimmerSpeed = 400
//        logoShimmerView.isShimmering = true

    }
    

    @IBAction func Login_btn_pressed(_ sender: UIButton) {
        guard let email = Email_txtField.text ,
              let password = password_txtField.text,
              password.count >= 8,
              !email.isEmpty
              else {
            alertUserLoginError(msg: "Please enter all information to log in")
            return
        }
        snipper.show(in: view)
        //login
        AuthManager.shared.login(email: email, password: password) { (succeed) in
            if succeed {
                DatabaseManager.shared.downloadCurrentUsername(email: email) { (result) in
                    switch result {
                    case .success(let username) :
                        LoginViewController.username = username
                        UserDefaults.standard.set(username, forKey: "username")
                        print("el username elly fl login viewcontroller...... \(LoginViewController.username!)")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password, forKey: "password")
                        self.snipper.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error) :
                        self.snipper.dismiss()
                        print("error on get username \(error)")
                    }
                }
               
            }
            else {
                self.snipper.dismiss()
                self.alertUserLoginError(msg: "Can't login with this email")
            }
        }
    }
    
    @IBAction func signUp_btn_pressed(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let RegistrationVC = storyBoard.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        //RegistrationVC.modalPresentationStyle = .fullScreen
        RegistrationVC.title = "Create Account"
        DispatchQueue.main.async {
            //self.navigationController?.pushViewController(RegistrationVC, animated: true)
            self.present(RegistrationVC, animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError(msg:String) {
        let alert = UIAlertController(title: "",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == Email_txtField {
            password_txtField.becomeFirstResponder()
        }
        if textField == password_txtField {
            login_btn.becomeFirstResponder()
        }
        return true
    }
}

