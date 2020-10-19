//
//  SignUpViewController.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/18/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    private var signUpWithEmailLabel: UILabel!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var emailSignInButton: UIButton!

    private var signUpLabel: UILabel!
    private var returnToSignInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    
        setupEmailSignInLabel()
        setupUserNameTextField()
        setupPasswordTextField()
        setupEmailSignInButton()
        
        setupSignUpLabel()
        setupReturnToSignInButton()
    }
    
    
    // MARK: - Email Sign Up
    
    private func setupEmailSignInLabel() {
        signUpWithEmailLabel = UILabel()
        signUpWithEmailLabel.text = "Sign Up With Email"
        signUpWithEmailLabel.textColor = .white
        signUpWithEmailLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        signUpWithEmailLabel.textAlignment = .center
        view.addSubview(signUpWithEmailLabel)
        
        signUpWithEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = signUpWithEmailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = signUpWithEmailLabel.heightAnchor.constraint(equalToConstant: 32)
        let centerXConstraint = signUpWithEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = signUpWithEmailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    private func setupUserNameTextField() {
        emailTextField =  UITextField(frame: CGRect())
        emailTextField.backgroundColor = .white
        emailTextField.placeholder = "Enter email here"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        emailTextField.autocapitalizationType = .none
        emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = emailTextField.heightAnchor.constraint(equalToConstant: 40)
        let centerXConstraint = emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = emailTextField.topAnchor.constraint(equalTo: signUpWithEmailLabel.bottomAnchor, constant: 20)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    private func setupPasswordTextField() {
        passwordTextField =  UITextField(frame: CGRect())
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "Enter password here"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.autocapitalizationType = .none
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        let centerXConstraint = passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    private func setupEmailSignInButton() {
        emailSignInButton = UIButton(frame: CGRect(), primaryAction: UIAction(title: "Sign Up", handler: { [weak self] action in
            // TODO: Call sign up with textField values
            self?.signUpWithEmail()
        }))
        emailSignInButton.backgroundColor = .lightGray
        emailSignInButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        emailSignInButton.layer.cornerRadius = 5
        view.addSubview(emailSignInButton)
        
        emailSignInButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = emailSignInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: 0)
        let heightConstraint = emailSignInButton.heightAnchor.constraint(equalToConstant: 40)
        let centerXConstraint = emailSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = emailSignInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    // MARK: - Sign In Button
    
    private func setupSignUpLabel() {
        signUpLabel = UILabel()
        signUpLabel.text = "Return To Sign In"
        signUpLabel.textColor = .white
        signUpLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        signUpLabel.textAlignment = .center
        view.addSubview(signUpLabel)
        
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = signUpLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = signUpLabel.heightAnchor.constraint(equalToConstant: 32)
        let centerXConstraint = signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = signUpLabel.topAnchor.constraint(equalTo: emailSignInButton.bottomAnchor, constant: 64)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    private func setupReturnToSignInButton() {
        returnToSignInButton = UIButton(frame: CGRect(), primaryAction: UIAction(title: "Go Back", handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        returnToSignInButton.backgroundColor = .darkGray
        returnToSignInButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        returnToSignInButton.layer.cornerRadius = 5
        view.addSubview(returnToSignInButton)
        
        returnToSignInButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = returnToSignInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: 0)
        let heightConstraint = returnToSignInButton.heightAnchor.constraint(equalToConstant: 40)
        let centerXConstraint = returnToSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = returnToSignInButton.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
}

// MARK: - Firebase Sign Up
// TODO: Alerts for errors
extension SignUpViewController {
    
    private func signUpWithEmail() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
              // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
            print("Error: Operation not allowed")
            case .emailAlreadyInUse:
              // Error: The email address is already in use by another account.
                print("Error: Email is already in Use")
            case .invalidEmail:
              // Error: The email address is badly formatted.
                print("Error: Invalid email")
            case .weakPassword:
              // Error: The password must be 6 characters long or more.
                print("Error: Weak password")
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
            // Successfully authenticated new user
            
            guard let currentUser = Auth.auth().currentUser else { return }

            if authResult?.additionalUserInfo?.isNewUser == true {
                let createUserUseCase = UseCaseProvider().createUserUseCase
                let displayName = currentUser.displayName ?? "JohnDoe"
                var username = displayName.replacingOccurrences(of: " ", with: "")
                username += String(Int.random(in: 1_000..<10_000))
                
                let user = User(id: currentUser.uid, name: currentUser.displayName ?? "John Doe", username: username, email: currentUser.email ?? "johndoe@gmail.com", dateCreated: Date(), userId: currentUser.uid, goalsTemplate: nil)
                
                createUserUseCase.execute(request: user) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }
          }
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
