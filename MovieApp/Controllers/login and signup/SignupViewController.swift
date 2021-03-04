//
//  SignupViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/7/21.
//

import UIKit
import ShimmerSwift
import SDWebImage
import FirebaseAuth
import JGProgressHUD

class SignupViewController: UIViewController {
    
    let snipper = JGProgressHUD(style: .dark)
    public static  var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    @IBOutlet weak var logo_lbl: UILabel!
    @IBOutlet weak var profile_imgView: UIImageView!
    
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var username_txtField: UITextField!
    @IBOutlet weak var Email_txtField: UITextField!
    @IBOutlet weak var Password_txtField: UITextField!
    
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        Password_txtField.textContentType = .oneTimeCode

        profile_imgView.layer.borderWidth = 4
        profile_imgView.layer.masksToBounds = false
        profile_imgView.layer.cornerRadius = profile_imgView.bounds.height / 2.0
        profile_imgView.clipsToBounds = true
        profile_imgView.layer.borderColor = UIColor.systemPink.cgColor
        profile_imgView.contentMode = .scaleAspectFit
        
        
        username_txtField.layer.cornerRadius = 15
        username_txtField.layer.borderWidth = 2
        username_txtField.layer.borderColor = UIColor.systemPink.cgColor
        username_txtField.delegate = self
        
        Email_txtField.layer.cornerRadius = 15
        Email_txtField.layer.borderWidth = 2
        Email_txtField.layer.borderColor = UIColor.systemPink.cgColor
        Email_txtField.delegate = self
        
        Password_txtField.layer.cornerRadius = 15
        Password_txtField.layer.borderWidth = 2
        Password_txtField.layer.borderColor = UIColor.systemPink.cgColor
        Password_txtField.delegate = self
        
        login_btn.layer.cornerRadius = 15
        

        
//        //logo Shimmer View
//        let logoShimmerView = ShimmeringView(frame: logo_lbl.bounds)
//        view.addSubview(logoShimmerView)
//        logoShimmerView.center = logo_lbl.center
//        logoShimmerView.contentView = logo_lbl
//        
//        //login Shimmer View
//        let loginShimmerView = ShimmeringView(frame: login_btn.bounds)
//        view.addSubview(loginShimmerView)
//        loginShimmerView.center = login_btn.center
//        loginShimmerView.contentView = login_btn
//        //shimmer start
//        logoShimmerView.shimmerSpeed = 300
//        logoShimmerView.isShimmering = true
//        loginShimmerView.shimmerSpeed = 300
//        loginShimmerView.isShimmering = true
    }
    


    @IBAction func login_btn_pressed(_ sender: UIButton) {
        
        guard let email = Email_txtField.text ,
              let pass = Password_txtField.text ,
              let username = username_txtField.text,
              pass.count >= 8,
              !email.isEmpty,
              !pass.isEmpty,
              !username.isEmpty
        else {
            alertUserLoginError(msg: "Please enter all information to create a new account.")
            return
        }
        snipper.show(in: view)
        AuthManager.shared.signUp(email: email, password: pass) {
            (registered) in
            if registered {
                // save information of new User
                DatabaseManager.shared.SaveUser(user: MovieAppUser(username: username, email: email.SafeDB()))
                //Save profile picture
                guard let image = self.profile_imgView.image , let data = image.pngData() else {
                    return
                }
                let filename = "\(email.SafeDB())_profile_picture.png"
                StorageManager.shared.uploadProfilePicture(data: data, fileName: filename) { succed in
                    switch succed {
                    case .failure(let error) :
                        print("error in upload image to storage\(error)")
                    case .success(let imageURL) :
                        print("imageURL ..... \(imageURL)")
                        UserDefaults.standard.set(imageURL, forKey: "profileImage")
                    }
                }
                
                self.snipper.dismiss()
                self.dismiss(animated: true, completion: nil)
            } else {
                
            }
        }
    }
    
    @IBAction func change_photo_pressed(_ sender: UIButton) {
        print("changed")
        didTapChangeProfilePicture()
    }
    
    func alertUserLoginError(msg :String) {
        let alert = UIAlertController(title: "",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username_txtField {
            Email_txtField.becomeFirstResponder()
        }
        else if textField == Email_txtField {
            Password_txtField.becomeFirstResponder()
        }
        else if textField == Password_txtField {
            login_btn.becomeFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.Password_txtField
            && !self.Password_txtField.isSecureTextEntry) {
            self.Password_txtField.isSecureTextEntry = true
        }
        
        return true
    }
}
extension SignupViewController:UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    private func didTapChangeProfilePicture () {
        
        
        let alertController = UIAlertController(title: "Profile Picture", message: "Choose Profile Picture", preferredStyle: .alert)
        let TakePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let ChooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let CancleAction = UIAlertAction(title: "Cancle", style: .default) { (UIAlertAction) in
        }
        
        alertController.addAction(TakePhotoAction)
        alertController.addAction(ChooseFromLibraryAction)
        alertController.addAction(CancleAction)
        present(alertController, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("infoooo ..... \(info)")
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.profile_imgView.image = image
            }
        }

        dismiss(animated: true, completion: nil)
    }
    
    
}

