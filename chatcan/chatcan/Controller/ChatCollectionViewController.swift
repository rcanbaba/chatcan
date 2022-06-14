//
//  ChatTableViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 31.05.2022.
//

import UIKit
import Firebase
import CoreMedia
import AVFoundation

class ChatCollectionViewController: UICollectionViewController {
    
    public var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    let cellIdentifier = "cellIdentifier"
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    private var messages = [Message]()
    
    private lazy var inputContainerView: ChatInputContainerView = {
        let inputContainerView = ChatInputContainerView()
        inputContainerView.backgroundColor = UIColor.lightGray
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.delegate = self
        return inputContainerView
    }()
    
    private var inputContainerViewBottomAnchor: NSLayoutConstraint?

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
        view.addSubview(inputContainerView)
        inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        inputContainerViewBottomAnchor = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        inputContainerViewBottomAnchor?.isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
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
            messageRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
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
    
    private func uploadImageToFirebaseStorage(image: UIImage, completionHandler: @escaping (_ imageUrl: String) -> ()) {
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
                                completionHandler(url)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func uploadVideoToFirebaseStorage(videoUrl: URL) {
        let filename = UUID().uuidString + ".mov"
        let storageRef = Storage.storage().reference().child("message_movies").child(filename)
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        if let videoData = NSData(contentsOf: videoUrl) as Data? {
            let uploadTask = storageRef.putData(videoData, metadata: metadata) { metadata, error in
                if let error = error {
                    self.present(ChatCollectionViewController.getAlert(title: "Upload Error", message: error.localizedDescription), animated: true)
                    return
                } else {
                    storageRef.downloadURL { downloadUrl, error in
                        if let error = error {
                            self.present(ChatCollectionViewController.getAlert(title: "Download Url Error", message: error.localizedDescription), animated: true)
                            return
                        } else {
                            if let downloadUrl = downloadUrl?.absoluteString {
                                if let thumbnailImage = self.thumbnailImageForVideo(videoUrl: videoUrl) {
                                    self.uploadImageToFirebaseStorage(image: thumbnailImage) { imageUrl in
                                        self.sendVideoMessage(videoUrl: downloadUrl, thumbnailImageUrl: imageUrl, thumbnailImage: thumbnailImage)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            uploadTask.observe(.progress) { (snapshot) in
                if let completiontCount = snapshot.progress?.completedUnitCount {
                    self.navigationItem.title = String(completiontCount)
                }
            }
            uploadTask.observe(.success) { (snapshot) in
                self.navigationItem.title = self.user?.name
            }
        }
    }
    
    private func sendMessage(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { error, reference in
            if let error = error {
                self.present(LoginViewController.getAlert(title: "Reference Error", message: error.localizedDescription), animated: true)
                return
            } else {
                self.inputContainerView.inputTextField.text = nil
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                if let messageId = childRef.key {
                    userMessagesRef.updateChildValues([messageId : 1])
                    recipientUserMessagesRef.updateChildValues([messageId : 1])
                }
            }
        }
    }
    
    private func sendImageMessage(imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject,
                                               "imageWidth": image.size.width as AnyObject,
                                               "imageHeight": image.size.height as AnyObject]
        sendMessage(properties: properties)
    }
    
    private func sendVideoMessage(videoUrl: String, thumbnailImageUrl: String, thumbnailImage: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": thumbnailImageUrl as AnyObject,
                                               "imageWidth": thumbnailImage.size.width as AnyObject,
                                               "imageHeight": thumbnailImage.size.height as AnyObject,
                                               "videoUrl": videoUrl as AnyObject]
        self.sendMessage(properties: properties)
        
    }
    
    private func thumbnailImageForVideo(videoUrl: URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    
    private var blackBackgroundView: UIView?
    private var startingFrame: CGRect?
    private var startingImageView: UIImageView?
    
    private func performZoomIn(imageView: UIImageView) {
        self.startingImageView = imageView
        self.startingImageView?.isHidden = true
        
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = imageView.image
        zoomingImageView.isUserInteractionEnabled = true
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                }, completion: { (completed) in
//                    do nothing
            })
        }
    }
    
// MARK: ~ ACTIONS
    private func sendButtonTapped() {
        let properties = ["text": self.inputContainerView.inputTextField.text!]
        sendMessage(properties: properties as [String : AnyObject])
    }
    
    private func uploadImageTaped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [MediaType.photo.rawValue, MediaType.video.rawValue]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
                }, completion: { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
            })
            
        }
    }
    
// MARK: ~ NOTIFS - keyboard
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        inputContainerViewBottomAnchor?.constant = -keyboardFrame!.height + 32
        
        UIView.animate(withDuration: keyboardDuration!) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { (_) in
            if self.messages.count > 0 {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        inputContainerViewBottomAnchor?.constant = 0
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
        cell.delegate = self
        let message = messages[indexPath.item]
        cell.message = message
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
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }
}

// MARK: UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout
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

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ChatCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        if mediaType == MediaType.photo.rawValue {
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            uploadImageToFirebaseStorage(image: image) { imageUrl in
                self.sendImageMessage(imageUrl: imageUrl, image: image)
            }
        } else {
            guard let videoUrl = info[.mediaURL] as? URL else {
                return
            }
            uploadVideoToFirebaseStorage(videoUrl: videoUrl)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: ChatCollectionViewCellDelegate
extension ChatCollectionViewController: ChatCollectionViewCellDelegate {
    func imageTapped(cell: ChatCollectionViewCell, imageView: UIImageView) {
        performZoomIn(imageView: imageView)
    }
}

// MARK: ChatInputContainerViewDelegate
extension ChatCollectionViewController: ChatInputContainerViewDelegate {
    func sendButtonTapped(view: ChatInputContainerView) {
        sendButtonTapped()
    }
    func uploadMediaButtonTapped(view: ChatInputContainerView) {
        uploadImageTaped()
    }
}
