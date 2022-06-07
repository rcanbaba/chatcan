//
//  LoginViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private enum MediaType: String {
        case photo = "public.image"
        case video = "public.movie"
    }
    
    private lazy var loginView = LoginView()
    private var profileImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Login.blackbg
        setNeedsStatusBarAppearanceUpdate()
        loginView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        self.view = loginView
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(uid)
        
        userRef.updateChildValues(values as [AnyHashable : Any]) { error, reference in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Reference Error", message: error.localizedDescription), animated: true)
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginButtonTapped(view: LoginView, email: String?, password: String?) {
        Auth.auth().signIn(withEmail: email!, password: password!) { response, error in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Login Error", message: error.localizedDescription), animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func registerButtonTapped(view: LoginView, email: String?, password: String?, name: String?) {
        Auth.auth().createUser(withEmail: email!, password: password!) { response, error in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Register Error", message: error.localizedDescription), animated: true)
            } else {
                guard let userID = response?.user.uid else { return }
                
                if let uploadData = self.profileImage.jpegData(compressionQuality: 0.2) {
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                    storageRef.putData(uploadData, metadata: nil) { metadata, error in
                        if let error = error {
                            self.present(LoginViewController.getAlert(title: "Upload Error", message: error.localizedDescription), animated: true)
                            return
                        } else {
                            storageRef.downloadURL { url, error in
                                if let error = error {
                                    self.present(LoginViewController.getAlert(title: "Download Url Error", message: error.localizedDescription), animated: true)
                                    return
                                } else {
                                    if let url = url?.absoluteString {
                                        if let values = ["name": name, "email": email, "profileImageUrl": url] as [String: AnyObject]? {
                                            self.registerUserIntoDatabaseWithUID(uid: userID, values: values)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if let values = ["name": name, "email": email] as [String: AnyObject]? {
                        self.registerUserIntoDatabaseWithUID(uid: userID, values: values)
                    }
                }
            }
        }
    }
    
    func handleProfileImageTap(view: LoginView) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        if mediaType == MediaType.photo.rawValue {
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            loginView.setProfileImage(image: image)
            profileImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
