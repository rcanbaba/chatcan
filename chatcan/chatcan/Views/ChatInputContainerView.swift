//
//  ChatInputContainerView.swift
//  chatcan
//
//  Created by Can Babaoğlu on 14.06.2022.
//

import UIKit

protocol ChatInputContainerViewDelegate: AnyObject {
    func sendButtonTapped(view: ChatInputContainerView)
    func uploadMediaButtonTapped(view: ChatInputContainerView)
}

class ChatInputContainerView: UIView {
    
    public weak var delegate: ChatInputContainerViewDelegate?
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Custom.textDarkBlue
        button.setTitle("Send", for: .normal)
        button.layer.cornerRadius = 10.0
        button.setTitleColor(UIColor.Custom.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter message..."
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.textDarkBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.Custom.ligthBlue
        textField.layer.cornerRadius = 12.0
        textField.delegate = self
        textField.setPadding(left: 6, right: 4)
        return textField
    }()
    
    private lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "upload-image-msg-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped)))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        self.addSubview(uploadImageView)
        uploadImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        uploadImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        sendButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -48).isActive = true
        
        self.addSubview(inputTextField)
        inputTextField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -60).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.Custom.textDarkBlue
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLineView)
        separatorLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: self.topAnchor, constant: -2).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
// MARK: ACTIONS
    @objc func sendButtonTapped() {
        delegate?.sendButtonTapped(view: self)
    }
    @objc func uploadImageTapped() {
        delegate?.uploadMediaButtonTapped(view: self)
    }
}

extension ChatInputContainerView: UITextFieldDelegate {
    // to send message by tapping enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.sendButtonTapped(view: self)
        return true
    }
}
