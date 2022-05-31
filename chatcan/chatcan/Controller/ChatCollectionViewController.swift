//
//  ChatTableViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 31.05.2022.
//

import UIKit
import Firebase

class ChatCollectionViewController: UICollectionViewController {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.purple1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Login.button
        button.setTitle("Send", for: .normal)
        button.layer.cornerRadius = 10.0
        button.setTitleColor(UIColor.Custom.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.purple2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat Logs"
        collectionView.backgroundColor = UIColor.Custom.appWhite
        
        configureUI()
    }
    
    private func configureUI() {
        configureInputComponents()
    }
    
    private func configureInputComponents() {
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -16).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -16).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.Custom.borderGray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    @objc func sendButtonTapped() {
        
    }

}
