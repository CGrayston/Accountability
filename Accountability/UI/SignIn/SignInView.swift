//
//  SignInView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/5/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var coordinator: SignInWithAppleCoordinator?
    
//    @State var showTaskListView = false
    
    var body: some View {
        VStack {
            Text("Please Sign In Here")
            
//            SignInWithAppleButton()
//                .frame(width: 280, height: 45)
//                .onTapGesture {
//                    self.coordinator = SignInWithAppleCoordinator()
//                    if let coordinator = self.coordinator {
//                        coordinator.startSignInWithAppleFlow {
//                            // Successfully signed in
//                            //self.showTaskListView.toggle()
//                            self.presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//            }
            
            SignInWithGoogleButton()
                .frame(width: 280, height: 45)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
