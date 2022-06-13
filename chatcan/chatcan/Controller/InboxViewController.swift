//
//  ViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit
import Firebase

class InboxViewController: UITableViewController {
    
    let cellIdentifier = "cellIdentifier"
    
    private var messageTableViewController: MessageTableViewController?
    
    private var messages = [Message]()
    private var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setNavigationBar()
        checkIfUserLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfUserLoggedIn()
        observeUserMessages()
    }
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new-message-icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        navigationController?.navigationBar.tintColor = UIColor.Custom.textDarkBlue
    }
    
    private func checkIfUserLoggedIn() {
        guard Auth.auth().currentUser != nil else {
            DispatchQueue.main.async { [weak self] in
                self?.handleLogout()
            }
            return
        }
        fetchUserAndSetupNavBarTitle()
    }
    
    private func fetchUserAndSetupNavBarTitle() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                if let value = snapshot.value as? NSDictionary {
                    let user = User()
                    user.name = value["name"] as? String ?? ""
                    user.email = value["email"] as? String ?? ""
                    user.profileImageUrl = value["profileImageUrl"] as? String ?? ""
                    self.setupNavBarWithUser(user: user)
                }
            } withCancel: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavBarWithUser(user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.isUserInteractionEnabled = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20.0
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl, profileImageUrl != "" {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "empty-profile-icon")
        }
        
        containerView.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    }
    
    private func observeUserMessages() {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { snapshot in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observeSingleEvent(of: .childAdded) { snapshot in
                let messageId = snapshot.key
                self.fetchMessageAndReloadTable(messageId: messageId)
            } withCancel: { error in
                print(error.localizedDescription)
            }
        }
        
        ref.observe(.childRemoved) { snapshot in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.reloadTableViewWithDelay()
        }
    }
    
    private func reloadTableViewWithDelay() {
        self.messages = Array(self.messagesDictionary.values)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func fetchMessageAndReloadTable(messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value) { snapshot in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                let chatPartnerId = message.chatPartnerId()
                if let chatPartnerId = chatPartnerId {
                    self.messagesDictionary[chatPartnerId] = message
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return Int(truncating: message1.timestamp ?? 0) > Int(truncating: message2.timestamp ?? 0)
                    })
                    self.reloadTableViewWithDelay()
                }
            }
        } withCancel: { error in
            print(error.localizedDescription)
        }
    }
    
    private func showChatController (user: User) {
        let chatController = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    // MARK: ~ ACTIONS
    @objc func handleLogout () {
        do {
            try Auth.auth().signOut()
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
    }
    
    @objc func handleNewMessage () {
        messageTableViewController = MessageTableViewController()
        messageTableViewController?.delegate = self
        let messageNavigationController = UINavigationController(rootViewController: messageTableViewController!)
        messageNavigationController.modalPresentationStyle = .fullScreen
        present(messageNavigationController, animated: true, completion: nil)
    }
}

// MARK: ~ TABLEVIEW
extension InboxViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        
        return configureCell(cell: cell, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else { return }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSDictionary {
                let user = User()
                user.id = chatPartnerId
                user.name = value["name"] as? String ?? ""
                user.email = value["email"] as? String ?? ""
                user.profileImageUrl = value["profileImageUrl"] as? String ?? ""
                self.showChatController(user: user)
            }
        } withCancel: { error in
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
            let reference = Database.database().reference().child("user-messages").child(uid).child(chatPartnerId)
            reference.removeValue { error, ref in
                if error != nil {
                    print("Failed to delete message:", error?.localizedDescription)
                    return
                }
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.reloadTableViewWithDelay()
            }
        }
        
    }
    
}

// MARK: ~ CELL
extension InboxViewController {
    private func configureCell(cell: UserTableViewCell, indexPath: IndexPath) -> UserTableViewCell {
        let message = messages[indexPath.row]
        
        if let id = message.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value) { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            } withCancel: { error in
                print(error.localizedDescription)
            }
        }
        
        if let time = message.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
        }
        cell.detailTextLabel?.text = message.text
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

// MARK: ~ MessageTableViewControllerDelegate
extension InboxViewController: MessageTableViewControllerDelegate {
    func userSelected(controller: UITableViewController, user: User) {
        showChatController(user: user)
    }
}
