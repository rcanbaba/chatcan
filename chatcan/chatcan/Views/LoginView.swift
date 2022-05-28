//
//  LoginView.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit

class LoginView: UIView {
    
    private lazy var userInputView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.appWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Login.background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.Custom.purple2.cgColor
        view.layer.borderWidth = 16.0
        view.layer.cornerRadius = 32.0
        return view
    }()
    
    private lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Login.button
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 10.0
        button.setTitleColor(UIColor.Custom.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.purple2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.purple2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.purple2
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Login.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Login.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chatcan-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func configureUI() {
        addSubview(borderView)
        addSubview(userInputView)
        addSubview(loginRegisterButton)
        addSubview(profileImageView)
        
        configureBorderView()
        configureUserInputView()
        configureLoginRegisterButton()
        configureProfileImageView()
    }
    

    private func configureBorderView() {
        NSLayoutConstraint.activate([
            borderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            borderView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            borderView.heightAnchor.constraint(equalTo: heightAnchor, constant: -128)
        ])
    }
    
    private func configureUserInputView() {
        NSLayoutConstraint.activate([
            userInputView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userInputView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userInputView.widthAnchor.constraint(equalTo: widthAnchor, constant: -96),
            userInputView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        userInputView.addSubview(nameTextField)
        userInputView.addSubview(nameSeparatorView)
        userInputView.addSubview(emailTextField)
        userInputView.addSubview(emailSeparatorView)
        userInputView.addSubview(passwordTextField)
                
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: userInputView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -12),
            nameTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            nameSeparatorView.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeparatorView.widthAnchor.constraint(equalTo: userInputView.widthAnchor),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor, constant: 12),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            emailTextField.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -12),
            emailTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            emailSeparatorView.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor),
            emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeparatorView.widthAnchor.constraint(equalTo: userInputView.widthAnchor),
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor, constant: 12),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -12),
            passwordTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: 1/3)
        ])
        
    }
    
    private func configureLoginRegisterButton() {
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: userInputView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -32),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureProfileImageView() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: userInputView.topAnchor, constant: -12),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
