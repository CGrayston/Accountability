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
    
    @ObservedObject var viewModel: SettingsViewModel
//    @State private var showingErrorAlert = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Header(title: "User")) {
                    UserField(fieldName: "Username:", binding: $viewModel.user.username)
                    UserField(fieldName: "Name:", binding: $viewModel.user.name)
                    UserField(fieldName: "Email:", binding: $viewModel.user.email, isEditable: true)
                }
                
                Section(header: Header(title: "Loging")) {
                    Text("Log Out")
                        .onTapGesture {
                            viewModel.logOutUser()
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct Header: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .frame(height: 40)
    }
}

struct UserField: View {
    
    var fieldName: String
    var binding: Binding<String>
    var isEditable: Bool?
    
    var body: some View {
        HStack(alignment: .center, spacing: 20, content: {
            Text(fieldName)

            TextField(fieldName, text: binding)
                    .disabled(isEditable == true)
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
