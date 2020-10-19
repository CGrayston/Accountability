//
//  SignInViewController.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import Firebase

class SignInViewController: UIViewController {
    
    private var signInWithGoogleLabel: UILabel!
    private var googleSignInButton: GIDSignInButton!
    
    private var signInWithEmailLabel: UILabel!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var emailSignInButton: UIButton!

    private var signUpLabel: UILabel!
    private var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self

        view.backgroundColor = .systemBlue
        
        setupGoogleSignInLabel()
        setupGoogleSignInButton()
        
        setupEmailSignInLabel()
        setupUserNameTextField()
        setupPasswordTextField()
        setupEmailSignInButton()
        
        setupSignUpLabel()
        setupSignUpButton()
    }
    
    // MARK: - Google Sign In
    
    private func setupGoogleSignInLabel() {
        signInWithGoogleLabel = UILabel()
        signInWithGoogleLabel.text = "Sign In With Google"
        signInWithGoogleLabel.textColor = .white
        signInWithGoogleLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        signInWithGoogleLabel.textAlignment = .center
        view.addSubview(signInWithGoogleLabel)
        
        signInWithGoogleLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = signInWithGoogleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = signInWithGoogleLabel.heightAnchor.constraint(equalToConstant: 32)
        let centerXConstraint = signInWithGoogleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = signInWithGoogleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 128)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    private func setupGoogleSignInButton() {
        googleSignInButton = GIDSignInButton(frame: CGRect())
        googleSignInButton.colorScheme = .light
        view.addSubview(googleSignInButton)
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = googleSignInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: 0)
        let centerXConstraint = googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = googleSignInButton.topAnchor.constraint(equalTo: signInWithGoogleLabel.bottomAnchor, constant: 20)
        
        view.addConstraints([widthConstraint, centerXConstraint, topConstraint])
    }
    
    // MARK: - Email Sign In
    
    private func setupEmailSignInLabel() {
        signInWithEmailLabel = UILabel()
        signInWithEmailLabel.text = "Sign In With Email"
        signInWithEmailLabel.textColor = .white
        signInWithEmailLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        signInWithEmailLabel.textAlignment = .center
        view.addSubview(signInWithEmailLabel)
        
        signInWithEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = signInWithEmailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = signInWithEmailLabel.heightAnchor.constraint(equalToConstant: 32)
        let centerXConstraint = signInWithEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = signInWithEmailLabel.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 64)
        
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
        let topConstraint = emailTextField.topAnchor.constraint(equalTo: signInWithEmailLabel.bottomAnchor, constant: 20)
        
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
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.autocapitalizationType = .none
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
        emailSignInButton = UIButton(frame: CGRect(), primaryAction: UIAction(title: "Sign In", handler: { [weak self] action in
            self?.signInWithEmail()
        }))
        emailSignInButton.backgroundColor = .orange
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
    
    // MARK: - Sign Up Button
    
    private func setupSignUpLabel() {
        signUpLabel = UILabel()
        signUpLabel.text = "Sign Up With New Account"
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
    
    private func setupSignUpButton() {
        signUpButton = UIButton(frame: CGRect(), primaryAction: UIAction(title: "Sign Up", handler: { [weak self] action in
            // TODO: Navigate to Sign Up
            self?.present(SignUpViewController(), animated: true)
            print("Tapped sign up")
        }))
        signUpButton.backgroundColor = .lightGray
        signUpButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        signUpButton.layer.cornerRadius = 5
        view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: 0)
        let heightConstraint = signUpButton.heightAnchor.constraint(equalToConstant: 40)
        let centerXConstraint = signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = signUpButton.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
}

// MARK: - Firebase Login

extension SignInViewController {
    
    private func signInWithEmail() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        // TODO: Alerts for errors
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    print("Error: Operation not allowed")
                case .userDisabled:
                // Error: The user account has been disabled by an administrator.
                    print("Error: User Disabled")
                case .wrongPassword:
                // Error: The password is invalid or the user does not have a password.
                    print("Error: Wrong Password")
                case .invalidEmail:
                // Error: Indicates the email address is malformed.
                print("Error: Invalid email")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                // Signed in successfully. Maybe put stuff here later
                print("User signs in successfully")
                let userInfo = Auth.auth().currentUser
                let _ = userInfo?.email
            }
        }
    }
}

// MARK: - UITextFieldDelegate Methods

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
