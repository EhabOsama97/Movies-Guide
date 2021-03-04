//
//  HamburgerViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/10/21.
//

import UIKit

protocol MenuViewControllerDelegate {
    func ProfileButtonPressed()
    func SettingButtonPressed()
    func logoutButtonPressed()
    func privacyButtenPressed()
}

class MenuViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var Switch_btn: UISwitch!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profile_imageView: UIImageView!
    public var delegate:MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustProfileData()
        checkDarkMode()
        setupHamburgerUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private func setupHamburgerUI() {
        profile_imageView.layer.borderWidth = 4
        profile_imageView.layer.masksToBounds = false
        profile_imageView.layer.cornerRadius = profile_imageView.bounds.height / 2.0
        profile_imageView.clipsToBounds = true
        profile_imageView.layer.borderColor = UIColor.white.cgColor
        profile_imageView.contentMode = .scaleAspectFit
        
        backView.layer.cornerRadius = 27
        backView.clipsToBounds = true
        
    }
    private func checkDarkMode() {
        
       if #available(iOS 13, *) {
        
            if traitCollection.userInterfaceStyle == .dark {
                Switch_btn.isOn = true
                    } else {
                        Switch_btn.isOn = false
                    }
              }
        
 
    }
    
    @IBAction func Profile_btn_Pressed(_ sender: UIButton) {
        self.delegate?.ProfileButtonPressed()
    }
    
    @IBAction func Setting_btn_Pressed(_ sender: UIButton) {
        delegate?.SettingButtonPressed()
    }
    
    @IBAction func Privacy_pressed(_ sender: UIButton) {
        delegate?.privacyButtenPressed()
    }
    
    @IBAction func logout_pressed(_ sender: UIButton) {
     
        delegate?.logoutButtonPressed()
        
    }
    
    @IBAction func DarkMode_SwitchBtn(_ sender: UISwitch) {
        if (sender.isOn == true)
        {
            
        }
        else {
            UIWindow.appearance().overrideUserInterfaceStyle = .light
  
        }
    }
    
    func adjustProfileData () {
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let usernamee = UserDefaults.standard.value(forKey: "username") as? String
           {
            print("dkhal fl lett ")
            username.text = usernamee
            //image
            let imagepath = "images/\(email.SafeDB())_profile_picture.png"
            StorageManager.shared.downlaodURL(path: imagepath) { [self] (result) in
                switch result {
                case .failure(let error) :
                    print("error in download profile image \(error)")
                case .success(let url) :
                    print(url)
                    DispatchQueue.main.async {
                        profile_imageView.sd_setImage(with: url, completed: nil)
                    }
                    
                }
            }
            
        }
        print("khrag mn el lett ")
    }
    
    
    @IBAction func Geasture_tapped(_ sender: UITapGestureRecognizer) {
        print("dost")
        self.viewDidLoad()
    }
    @IBAction func view_Geasture_tapped(_ sender: UITapGestureRecognizer) {
        print("dost 3l kber")
        self.viewDidLoad()
    }
}

