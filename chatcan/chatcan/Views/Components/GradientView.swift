//
//  GradientView.swift
//  chatcan
//
//  Created by Can Babaoğlu on 7.06.2022.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.gradientLayer.frame = self.bounds
    }
}
