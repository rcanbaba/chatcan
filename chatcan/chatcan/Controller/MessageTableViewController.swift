//
//  MessageTableViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 29.05.2022.
//

import UIKit
import Firebase

class MessageTableViewController: UITableViewController {
    
    let cellIdentifier = "cellIdentifier"
    
    private var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        fetchUser()
    }
    
    private func fetchUser () {
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            if let value = snapshot.value as? NSDictionary {
                let user = User()
                user.name = value["name"] as? String ?? ""
                user.email = value["email"] as? String ?? ""
                user.profileImageUrl = value["profileImageUrl"] as? String ?? ""
                self.users.append(user)
                // better approach instead of reload all tableview
                self.tableView.insertRows(
                    at: [IndexPath(row: self.users.count - 1, section: 0)],
                    with: .automatic
                )
            }
        } withCancel: { error in
            print(error.localizedDescription)
        }
    }
    
    @objc func handleCancel () {
        dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }

}
