//
//  UserTableViewCell.swift
//  chatcan
//
//  Created by Can Babaoğlu on 29.05.2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty-profile-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.Custom.textDarkBlue
        detailTextLabel?.textColor = UIColor.Custom.textDarkBlue
        self.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(timeLabel)
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 76, y: textLabel!.frame.origin.y - 3 , width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 76, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
}
