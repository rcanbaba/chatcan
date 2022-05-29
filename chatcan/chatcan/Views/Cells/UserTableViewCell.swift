//
//  UserTableViewCell.swift
//  chatcan
//
//  Created by Can Babaoğlu on 29.05.2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
