//
//  LoginViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Login.background
        setNeedsStatusBarAppearanceUpdate()        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        self.view = loginView
    }
}
