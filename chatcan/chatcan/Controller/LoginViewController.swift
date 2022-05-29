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
    
    private lazy var loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Login.background
        setNeedsStatusBarAppearanceUpdate()
        loginView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        self.view = loginView
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginButtonTapped(view: LoginView, email: String?, password: String?) {
        Auth.auth().signIn(withEmail: email!, password: password!) { response, error in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Login Error", message: error.localizedDescription), animated: true)
            } else {
                print("login")
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
                
                let ref = Database.database().reference(fromURL: "gs://chatcan-44462.appspot.com")
                let userRef = ref.child("users").child(userID)
                let values = ["name": name, "email": email]
                
                userRef.updateChildValues(values as [AnyHashable : Any]) { error, reference in
                    if let error = error {
                        self.present(LoginViewController.getAlert(title: "Reference Error", message: error.localizedDescription), animated: true)
                        return
                    } else {
                        print("saved")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
