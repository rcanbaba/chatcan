//
//  LoginView.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonTapped(view: LoginView, email: String?, password: String?)
    func registerButtonTapped(view: LoginView, email: String?, password: String?, name: String?)
}

class LoginView: UIView {
    
    public weak var delegate: LoginViewDelegate?
    
    private lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login", "Register"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = UIColor.white
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return segment
    }()
    
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
        button.addTarget(self, action: #selector(loginRegisterButtonTapped), for: .touchUpInside)
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
        addSubview(loginRegisterSegmentedControl)
        
        configureBorderView()
        configureUserInputView()
        configureLoginRegisterButton()
        configureProfileImageView()
        configureSegmentedControlView()
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
        userInputViewHeightAnchor = userInputView.heightAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate([
            userInputView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userInputView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userInputView.widthAnchor.constraint(equalTo: widthAnchor, constant: -96),
        ])
        userInputViewHeightAnchor?.isActive = true
        
        userInputView.addSubview(nameTextField)
        userInputView.addSubview(nameSeparatorView)
        userInputView.addSubview(emailTextField)
        userInputView.addSubview(emailSeparatorView)
        userInputView.addSubview(passwordTextField)
                
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: 1/3)
        nameTextField.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: userInputView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -12).isActive = true
        nameTextFieldHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            nameSeparatorView.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeparatorView.widthAnchor.constraint(equalTo: userInputView.widthAnchor),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: 1/3)
        emailTextField.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -12).isActive = true
        emailTextFieldHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            emailSeparatorView.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor),
            emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeparatorView.widthAnchor.constraint(equalTo: userInputView.widthAnchor),
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: 1/3)
        passwordTextField.leadingAnchor.constraint(equalTo: userInputView.leadingAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: userInputView.widthAnchor, constant: -12).isActive = true
        passwordTextFieldHeightAnchor?.isActive = true
        
        
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
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureSegmentedControlView() {
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: userInputView.topAnchor, constant: -12),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: userInputView.widthAnchor, multiplier: 1),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private var userInputViewHeightAnchor: NSLayoutConstraint?
    private var nameTextFieldHeightAnchor: NSLayoutConstraint?
    private var emailTextFieldHeightAnchor: NSLayoutConstraint?
    private var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    @objc func loginRegisterButtonTapped () {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            delegate?.loginButtonTapped(view: self, email: emailTextField.text, password: passwordTextField.text)
        } else {
            delegate?.registerButtonTapped(view: self, email: emailTextField.text, password: passwordTextField.text, name: nameTextField.text)
        }
    }
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControl.State())
        
        userInputViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0

        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true

        //
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: userInputView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
}
