//
//  UIViewControllerExtension.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit


extension UIViewController {
        
    static func getAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
}
