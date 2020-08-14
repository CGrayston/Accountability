//
//  SettingsView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/9/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    var body: some View {
        VStack {
            List {
                Section(header: Header()) {
                    Text("Log Out")
                        .onTapGesture {
                            do {
                                let firebaseAuth = Auth.auth()
                                try firebaseAuth.signOut()
                            } catch let signOutError as NSError {
                                print ("Error signing out: %@", signOutError)
                            }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct Header: View {
    var body: some View {
        Text("Loging")
            .frame(height: 40)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
