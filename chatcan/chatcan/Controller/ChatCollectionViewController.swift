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
    private var containerViewBottomAnchor: NSLayoutConstraint?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
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
        textField.placeholder = " Enter message..."
        textField.setPlaceHolderColor(UIColor.Login.background)
        textField.textColor = UIColor.Custom.textDarkBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.Custom.ligthBlue
        textField.layer.cornerRadius = 12.0
        textField.delegate = self
        return textField
    }()
    
    private lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "upload-image-msg-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageTaped)))
        return imageView
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
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        configureInputComponents()
    }
    
    private func configureInputComponents() {
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        containerView.addSubview(uploadImageView)
        uploadImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        uploadImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -48).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -60).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.Custom.textDarkBlue
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -2).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessageRef.observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
    
    private func uploadImageToFirebaseStorage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("messsage_images").child("\(imageName).jpg")
        
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { metadata, error in
                if let error = error {
                    self.present(ChatCollectionViewController.getAlert(title: "Upload Error", message: error.localizedDescription), animated: true)
                    return
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            self.present(ChatCollectionViewController.getAlert(title: "Download Url Error", message: error.localizedDescription), animated: true)
                            return
                        } else {
                            if let url = url?.absoluteString {
                                self.sendImageMessage(imageUrl: url, image: image)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func sendImageMessage(imageUrl: String, image: UIImage) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        let values = ["toId": toId, "fromId": fromId, "timestamp": timestamp, "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        
        childRef.updateChildValues(values) { error, reference in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Reference Error", message: error.localizedDescription), animated: true)
                return
            } else {
                self.inputTextField.text = nil
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                if let messageId = childRef.key {
                    userMessagesRef.updateChildValues([messageId : 1])
                    recipientUserMessagesRef.updateChildValues([messageId : 1])
                }
            }
        }
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
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                if let messageId = childRef.key {
                    userMessagesRef.updateChildValues([messageId : 1])
                    recipientUserMessagesRef.updateChildValues([messageId : 1])
                }
            }
        }
    }
    
    @objc func uploadImageTaped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
// MARK: ~ NOTIFS - keyboard
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height + 32
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
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
        if let profileImageUrl = user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
        } else {
            cell.messageImageView.isHidden = true
        }
        message.fromId == Auth.auth().currentUser?.uid ? cell.setUI(messageType: .outgoing) : cell.setUI(messageType: .incoming)
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
        }
        return cell
    }
}

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
}

extension ChatCollectionViewController: UITextFieldDelegate {
    // to send message by tapping enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
    
}

extension ChatCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        if mediaType == MediaType.photo.rawValue {
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            uploadImageToFirebaseStorage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
