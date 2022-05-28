//
//  UITextFieldExtension.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit

extension UITextField{

    func setPlaceHolderColor(_ color : UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
