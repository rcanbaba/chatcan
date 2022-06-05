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
        return textview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        backgroundColor = UIColor.red
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
