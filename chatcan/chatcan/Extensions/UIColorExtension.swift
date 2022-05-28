//
//  UIColorExtension.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit

extension UIColor {
    convenience init(_ hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    struct Custom {
        static let ligthPurple = UIColor("AAAAE6")
        static let textDarkBlue = UIColor("282878")
        static let ligthBlue = UIColor("D2FAFA")
        static let appWhite = UIColor("F9F3FF")
        static let gray = UIColor("797084")
        static let borderGray = UIColor("AB9FBA")
        static let purple1 = UIColor("6F37B7")
        static let purple2 = UIColor("5D00D7")
    }
    
    struct Login {
        static let background = UIColor("AAAAE6")
        static let button = UIColor("5D00D7")
    }

}
