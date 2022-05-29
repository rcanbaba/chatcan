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
        
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                if let value = snapshot.value as? NSDictionary {
                    self.navigationItem.title = value["name"] as? String ?? ""
                }
            } withCancel: { error in
                print(error.localizedDescription)
            }
        }
            
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

}

