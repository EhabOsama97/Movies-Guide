//
//  ProfileViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/10/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var save_btn: UIButton!
    @IBOutlet weak var password_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var profile_imgView: UIImageView!
    
    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        save_btn.layer.cornerRadius = 20
        
        imagePicker.delegate = self
        
        profile_imgView.layer.borderWidth = 4
        profile_imgView.layer.masksToBounds = false
        profile_imgView.layer.cornerRadius = profile_imgView.bounds.height / 2.0
        profile_imgView.clipsToBounds = true
        profile_imgView.layer.borderColor = UIColor.white.cgColor
        profile_imgView.contentMode = .scaleAspectFit
        
        
        adjustProfileData()

    }
    
    @IBAction func change_photo_pressed(_ sender: UIButton) {
        didTapChangeProfilePicture()
    }
    
    @IBAction func Save_btn_pressed(_ sender: UIButton) {
        print("Save Pressed")
        
        if let email = UserDefaults.standard.value(forKey: "email") as? String
        ,let image = self.profile_imgView.image
        ,let data = image.pngData(){
            print("dkhal fl let email")
            
            let imagepath = "\(email.SafeDB())_profile_picture.png"
            StorageManager.shared.deleteProfilePicture(fileName: imagepath) { (succeed) in
                if succeed {
                    print("image deleted ...")
                    StorageManager.shared.uploadProfilePicture(data: data, fileName: imagepath) { (result) in
                        switch result {
                        case .success(let url ) :
                            print("image uploaded ...")
                            DispatchQueue.main.async {
                                self.profile_imgView.sd_setImage(with: URL(string: url), completed: nil)
                            }
                        case .failure(let error) :
                            print("error in upload profile picture\(error)")
                        }
                    }
                } else {
                    print("failedd")
                    
                }
            }
        }
        
    }
    
    
    func adjustProfileData () {
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let password = UserDefaults.standard.value(forKey: "password") as? String
           ,let username = UserDefaults.standard.value(forKey: "username") as? String
           {
            print("dkhal fl lett ")
            print("login username ..... \(username)")
            email_lbl.text = email
            password_lbl.text = password
            username_lbl.text = username
            //image
            let imagepath = "images/\(email.SafeDB())_profile_picture.png"
            StorageManager.shared.downlaodURL(path: imagepath) { [self] (result) in
                switch result {
                case .failure(let error) :
                    print("error in download profile image \(error)")
                case .success(let url) :
                    print(url)
                    DispatchQueue.main.async {
                        profile_imgView.sd_setImage(with: url, completed: nil)
                    }
                    
                }
            }
            
        }
        print("khrag mn el lett ")
    }
}

extension ProfileViewController:UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
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
