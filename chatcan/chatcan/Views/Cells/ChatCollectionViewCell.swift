//
//  ChatCollectionViewCell.swift
//  chatcan
//
//  Created by Can Babaoğlu on 5.06.2022.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    public lazy var textView: UITextView = {
        let textview = UITextView()
        textview.text = "SAMPLE TEXT FOR NOW"
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.backgroundColor = UIColor.clear
        textview.textColor = UIColor.Custom.textDarkBlue
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
    
    public var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(bubbleView)
        bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
