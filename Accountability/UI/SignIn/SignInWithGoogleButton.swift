//
//  SignInwithGoogleButton.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct SignInWithGoogleButton: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GIDSignInButton {
        let signInButton = GIDSignInButton()
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return signInButton
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
    }
}


//struct SignInWithGoogle_Previews: PreviewProvider {
//    static var previews: some View {
//        //SignInWithAppleButton()
//    }
//}
