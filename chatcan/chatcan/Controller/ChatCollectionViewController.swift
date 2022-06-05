//
//  ChatTableViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 31.05.2022.
//

import UIKit
import Firebase

class ChatCollectionViewController: UICollectionViewController {
    
    public var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    let cellIdentifier = "cellIdentifier"
    
    private var messages = [Message]()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.ligthBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        return view
    }()
    
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
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.textDarkBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.alwaysBounceVertical = true
        // top from navbar, bottom 108 height for send message input view
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 108, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Custom.textDarkBlue]
        navigationController?.navigationBar.tintColor = UIColor.Custom.textDarkBlue
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
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -48).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -48).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.Custom.textDarkBlue
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -2).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    private func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message()
                message.fromId = dictionary["fromId"] as? String ?? ""
                message.toId = dictionary["toId"] as? String ?? ""
                message.text = dictionary["text"] as? String ?? ""
                message.timestamp = dictionary["timestamp"] as? NSNumber ?? 0
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } withCancel: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    // to estimate bubble size cell textview
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
// MARK: ~ ACTIONS
    @objc func sendButtonTapped() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let text = inputTextField.text ?? "" as Any
        
        let values = ["text": text, "toId": toId, "fromId": fromId, "timestamp": timestamp ] as [String : Any]
        
        childRef.updateChildValues(values) { error, reference in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Reference Error", message: error.localizedDescription), animated: true)
                return
            } else {
                self.inputTextField.text = nil
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
                if let messageId = childRef.key {
                    userMessagesRef.updateChildValues([messageId : 1])
                    recipientUserMessagesRef.updateChildValues([messageId : 1])
                }
            }
        }
    }
    
    // to device transition, UI fix
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: ~ COLLECTION VIEW
extension ChatCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChatCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        return cell
    }
}

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }        
        return CGSize(width: view.frame.width, height: height)
    }
}

extension ChatCollectionViewController: UITextFieldDelegate {
    // to send message by tapping enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
    
}
