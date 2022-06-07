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
    func handleProfileImageTap(view: LoginView)
}

class LoginView: UIView {
    
    public weak var delegate: LoginViewDelegate?
    
    private lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login", "Register"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = UIColor.white
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        segment.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        segment.selectedSegmentTintColor = UIColor.Custom.purple2
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
        view.layer.borderWidth = 15.0
        view.layer.cornerRadius = 30.0
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
        imageView.image = UIImage(named: "edit-image-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(mytapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chatcan-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var topGradientView: GradientView = {
       let view = GradientView()
        view.clipsToBounds = true
        view.gradientLayer.locations = [0.0, 1.0]
        view.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        view.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomGradientView: GradientView = {
       let view = GradientView()
        view.clipsToBounds = true
        view.gradientLayer.locations = [0.0, 1.0]
        view.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        view.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    }
    
    private func configureUI() {
        addSubview(borderView)
        addSubview(topGradientView)
        addSubview(bottomGradientView)
        addSubview(userInputView)
        addSubview(loginRegisterButton)
        addSubview(profileImageView)
        addSubview(loginRegisterSegmentedControl)
        addSubview(logoImageView)
        
        configureBorderView()
        configureUserInputView()
        configureLoginRegisterButton()
        configureProfileImageView()
        configureSegmentedControlView()
        configureLogoImageView()
        configureGradientViews()
    }
    

    private func configureBorderView() {
        NSLayoutConstraint.activate([
            borderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            borderView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            borderView.heightAnchor.constraint(equalTo: heightAnchor, constant: -144)
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
    
    private func configureLogoImageView() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -42),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureGradientViews() {
        NSLayoutConstraint.activate([
            topGradientView.topAnchor.constraint(equalTo: topAnchor),
            topGradientView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: 300),
            topGradientView.widthAnchor.constraint(equalTo: widthAnchor)
        ])        
        NSLayoutConstraint.activate([
            bottomGradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomGradientView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 300),
            bottomGradientView.widthAnchor.constraint(equalTo: widthAnchor)
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
    
    @objc func handleSelectProfileImageView() {
        delegate?.handleProfileImageTap(view: self)
    }
}

extension LoginView {
    
    public func setProfileImage(image: UIImage){
        profileImageView.image = image
    }
    
}
