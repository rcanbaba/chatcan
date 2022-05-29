//
//  UIViewExtension.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit


extension UIView {
    
    static func createTextField (placeholder: String, isSecure : Bool = false, keyboardType : UIKeyboardType = UIKeyboardType.default) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = keyboardType
        tf.isSecureTextEntry = isSecure
        tf.placeholder = placeholder
        return tf
    }
    
}
