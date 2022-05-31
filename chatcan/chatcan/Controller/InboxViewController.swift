//
//  ViewController.swift
//  chatcan
//
//  Created by Can Babaoğlu on 28.05.2022.
//

import UIKit
import Firebase

class InboxViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray

        setNavigationBar()
        checkIfUserLoggedIn()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfUserLoggedIn()
    }
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new-message-icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
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
        
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
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
        let messageTableViewController = MessageTableViewController()
        let messageNavigationController = UINavigationController(rootViewController: messageTableViewController)
        messageNavigationController.modalPresentationStyle = .fullScreen
        present(messageNavigationController, animated: true, completion: nil)
    }

    @objc func showChatController () {
        let chatController = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatController, animated: true)
    }
}

