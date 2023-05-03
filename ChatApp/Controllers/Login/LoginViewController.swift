//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Berken Özbek on 28.04.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView : UIImageView = {
        
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private let emailField : UITextField = {
        
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 3
        field.layer.borderColor = UIColor.orange.cgColor
        field.placeholder = "  EMAIL"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .orange
        return field
    }()
    
    private let passwordField : UITextField = {
        
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 3
        field.layer.borderColor = UIColor.orange.cgColor
        field.placeholder = "  PASSWORD"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .orange
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.gray, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log In"
        view.backgroundColor = .gray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        
        
        emailField.delegate = self
        passwordField.delegate = self
        
        loginButton.addTarget(self, action: #selector(didTapLLogInButton), for: .touchUpInside)
        //görüntü işleme ve ekleme
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)

    }
    override func viewDidLayoutSubviews() {
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 80, width: size, height: 2*size)
        
        emailField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width-60 , height: 52)
        
        passwordField.frame = CGRect(x: 30, y: imageView.bottom + 80, width: scrollView.width-60 , height: 52)
        
        loginButton.frame = CGRect(x: 30, y: imageView.bottom + 150, width: scrollView.width-60 , height: 52)


    }
    
    @objc private func didTapLLogInButton(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text , let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6
        else{
            alertLogInUserError()
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] AuthDataResult, Error in
            guard let strongSelf = self else{
                return
            }
            guard let result = AuthDataResult, Error == nil else{
                print("Failed to login user with email..")
                return
            }
            let user = result.user
            print("Logged in user.. ")
            strongSelf.navigationController?.dismiss(animated: true)
            
        }
    }
    
    func alertLogInUserError(){
        
        let alert = UIAlertController(title: "ERROR", message: "Enter All Information To Log In.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel ))
        present(alert, animated: true )
    }

    @objc private func didTapRegister(){
        
        let viewControl = RegisterViewController()
        viewControl.title = "Create New Account"
        
        navigationController?.pushViewController(viewControl, animated: true)
        
    }
    


}
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            didTapLLogInButton()
        }
        
        return true
    }
    
}
