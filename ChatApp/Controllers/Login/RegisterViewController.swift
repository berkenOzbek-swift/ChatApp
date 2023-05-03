//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Berken Özbek on 28.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    private var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView : UIImageView = {
        
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "person.crop.circle")
        imageview.tintColor = .orange
        imageview.contentMode = .scaleAspectFit
        imageview.layer.masksToBounds = true
        imageview.layer.borderWidth = 2
        imageview.layer.borderColor = UIColor.lightGray.cgColor
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
    
    private let ConfirmPasswordField : UITextField = {
        
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 3
        field.layer.borderColor = UIColor.orange.cgColor
        field.placeholder = "  CONFIRM PASSWORD"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .orange
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("REGISTER", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.gray, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "REGISTER"
        view.backgroundColor = .gray
        
        
        
        emailField.delegate = self
        passwordField.delegate = self
        ConfirmPasswordField.delegate = self
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        //görüntü işleme ve ekleme
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(ConfirmPasswordField)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfile))
        //gesture.numberOfTapsRequired =
        //gesture.numberOfTouchesRequired =
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
    }
    @objc func didTapChangeProfile(){
        
        PresentPhotoActionSheet()
         
    }
    override func viewDidLayoutSubviews() {
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 80, width: size, height: 2*size)
        
        imageView.layer.cornerRadius = imageView.width/2.0
        
        emailField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width-60 , height: 52)
        
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width-60 , height: 52)
        
        ConfirmPasswordField.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: scrollView.width-60 , height: 52)
        
        registerButton.frame = CGRect(x: 30, y: ConfirmPasswordField.bottom + 10, width: scrollView.width-60 , height: 52)
        
        
    }
    @objc private func didTapRegisterButton() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        ConfirmPasswordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              let confirmPassword = ConfirmPasswordField.text,
              password.count >= 6,
              confirmPassword.count >= 6,
              password == confirmPassword else {
            if passwordField.text != ConfirmPasswordField.text {
                alertRegisterPasswordError()
            } else if passwordField.text!.count < 6 || ConfirmPasswordField.text!.count < 6 {
                alertPasswordCountError()
            } else {
                alertRegisterUserError()
            }
            return
        }
        databaseManager.share.userExists(with: email) { [weak self] exist in
            guard let strongSelf = self else{
                return
            }
            guard !exist else{
                strongSelf.alertRegisterUserError(message: "User already exist...")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: self?.emailField.text! ?? "error", password: (self?.passwordField.text! ?? "error")!) { [weak self] AuthDataResult, Error in
               
                guard let result = AuthDataResult, Error == nil else{
                    print("Error not created user.")
                    return
                }
                databaseManager.share.insertUser(with: databaseManager.ShareAppUser(emailAdress: email ))
                strongSelf.navigationController?.dismiss(animated: true)
            }
        }
        
       
    }

        
        
    func alertRegisterUserError(message : String = "Enter All Information To Log In."){
            
            let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel ))
            present(alert, animated: true )
        }
        func alertPasswordCountError(){
            
            let alert = UIAlertController(title: "ERROR", message: "Your passwords must be at least 6 digits.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel ))
            present(alert, animated: true )
        }
        func alertRegisterPasswordError(){
            
            let alert = UIAlertController(title: "ERROR", message: "Your passwords do not match Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel ))
            present(alert, animated: true )
        }
    }

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            didTapRegisterButton()
        }
        else if textField == ConfirmPasswordField{
            didTapRegisterButton()
        }
        
        return true
    }
    
}

extension RegisterViewController : UIImagePickerControllerDelegate{
    
    func PresentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How do you want to upload your profile photo?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Select Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    func presentCamera(){
        
        let takePhoto = UIImagePickerController()
        takePhoto.sourceType = .camera
        takePhoto.delegate = self
        takePhoto.allowsEditing = true
        present(takePhoto, animated: true)
        
    }
    func presentPhotoPicker(){
        
        let takePhoto = UIImagePickerController()
        takePhoto.sourceType = .photoLibrary
        takePhoto.delegate = self
        takePhoto.allowsEditing = true
        present(takePhoto, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else{
          return
      }
        self.imageView.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         
        picker.dismiss(animated: true)
    }
}
