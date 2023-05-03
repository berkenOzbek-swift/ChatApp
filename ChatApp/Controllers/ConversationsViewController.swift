//
//  ConversationsViewController.swift
//  ChatApp
//
//  Created by Berken Özbek on 28.04.2023.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    private func validateAuth(){
        
        if FirebaseAuth.Auth.auth().currentUser == nil{
            
            let viewControl = LoginViewController()
            let navigatonControl = UINavigationController(rootViewController: viewControl)
            navigatonControl.modalPresentationStyle = .fullScreen
            present(navigatonControl, animated: false)
            
        }
    }
    


}
