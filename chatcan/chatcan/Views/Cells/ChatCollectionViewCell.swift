//
//  ChatCollectionViewCell.swift
//  chatcan
//
//  Created by Can Babaoğlu on 5.06.2022.
//

import UIKit

enum MessageType: Int {
    case incoming = 0
    case outgoing = 1
}

protocol ChatCollectionViewCellDelegate: AnyObject {
    func imageTapped(cell: ChatCollectionViewCell, imageView: UIImageView)
}

class ChatCollectionViewCell: UICollectionViewCell {
    
    public weak var delegate: ChatCollectionViewCellDelegate?
    
    public lazy var textView: UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.backgroundColor = UIColor.clear
        textview.textColor = UIColor.Custom.textDarkBlue
        textview.isEditable = false
        return textview
    }()
    
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.ligthBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty-profile-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        return imageView
    }()
    
    public var bubbleWidthAnchor: NSLayoutConstraint?
    private var bubbleViewRightAnchor: NSLayoutConstraint?
    private var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
                
        addSubview(bubbleView)
        bubbleViewRightAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: ACTIONS
    @objc func imageTapped(_ tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.imageTapped(cell: self, imageView: imageView)
        }
    }
}

extension ChatCollectionViewCell {
    
    public func setUI(messageType: MessageType) {
        
        switch messageType {
        case .incoming:
            bubbleView.backgroundColor = UIColor.lightGray
            bubbleViewLeftAnchor?.isActive = true
            bubbleViewRightAnchor?.isActive = false
            profileImageView.isHidden = false
        case .outgoing:
            bubbleView.backgroundColor = UIColor.Custom.ligthBlue
            bubbleViewLeftAnchor?.isActive = false
            bubbleViewRightAnchor?.isActive = true
            profileImageView.isHidden = true
        }
    }
    
}
