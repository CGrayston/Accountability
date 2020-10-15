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


class SignInViewController: UIViewController {
    
    private var signInLabel: UILabel!
    private var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self

        setupSignInLabel()
        setupGoogleSignInButton()
    }
    
    private func setupSignInLabel() {
        signInLabel = UILabel()
        signInLabel.text = "Please Sign In"
        signInLabel.textColor = .white
        signInLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        signInLabel.textAlignment = .center
        view.addSubview(signInLabel)
        
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = signInLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 0)
        let heightConstraint = signInLabel.heightAnchor.constraint(equalToConstant: 32)
        let centerXConstraint = signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = signInLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 128)
        
        view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
    }
    
    private func setupGoogleSignInButton() {
        googleSignInButton = GIDSignInButton(frame: CGRect())
        googleSignInButton.colorScheme = .dark
        view.addSubview(googleSignInButton)
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = googleSignInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: 0)
        let centerXConstraint = googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = googleSignInButton.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 20)
        
        view.addConstraints([widthConstraint, centerXConstraint, topConstraint])
    }
}
