//
//  SettingsView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/9/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI
import Firebase

enum SettingsViewActiveAlert {
    case leaveGroup
}

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    @State var showingAlert: Bool = false
    @State var activeAlert: SettingsViewActiveAlert = .leaveGroup
    
    @State var showingCreateGroup: Bool = false
    
    @State var textCopied: Bool = false
        
    var body: some View {
        VStack {
            List {
                Section(header: Header(title: "User")) {
                    UserField(fieldName: "Username:", value: viewModel.user?.username ?? "No username")
                    UserField(fieldName: "Name:", value: viewModel.user?.name ?? "No name")
                    UserField(fieldName: "Email:", value: viewModel.user?.email ?? "No email")
                }
                
                // TODO: Implement Groups Feature
                Section(header: Header(title: "Groups")) {
                    if let groupId = viewModel.groupId {
                        // Click to copy group ID
                        Button(action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = groupId
                            textCopied = true
                        }) {
                            Label(title: { Text(textCopied ? "Copied to clipboard!" : "Click to copy group code: \(groupId)") }, icon: { Image(systemName: "doc.on.doc.fill").foregroundColor(.red) })
                        }
                        
                        // Leave Groups Button
                        Button(action: {
                            activeAlert = .leaveGroup
                            showingAlert = true
                        }) {
                            Label(title: { Text("Leave Group") }, icon: { Image(systemName: "person.crop.circle.fill.badge.minus").foregroundColor(.red) })
                        }
                    } else {
                        // Create Group
                        let createGroupUseCase = UseCaseProvider().createGroupUseCase
                        let createGroupViewModel = CreateGroupViewModel(createGroupUseCase: createGroupUseCase)
                        NavigationLink(destination: CreateGroupView(viewModel: createGroupViewModel)) {
                            Label("Create Group", systemImage: "person.crop.circle.fill.badge.plus")
                        }
                        
                        // Join Group
                        let joinGroupUseCase = UseCaseProvider().joinGroupUseCase
                        let joinGroupViewModel = JoinGroupViewModel(joinGroupUseCase: joinGroupUseCase)
                        NavigationLink(destination: JoinGroupView(viewModel: joinGroupViewModel)) {
                            Label("Join Group", systemImage: "person.3.fill")
                        }
                    }
                }
                
                Section(header: Header(title: "Loging")) {
                    Text("Log Out")
                        .onTapGesture {
                            viewModel.logOutButtonTapped()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                var title = ""
                var message = ""
                var primaryButton: Alert.Button?
                var secondaryButton: Alert.Button?
                
                switch activeAlert {
                case .leaveGroup:
                    title = "Leave Group?"
                    message = "Are you sure you want to leave your accountability group?"
                    primaryButton = Alert.Button.default(Text("Cancel"))
                    secondaryButton = Alert.Button.destructive(Text("Leave")) {
                        showingAlert = false
                        leaveGroupButtonTapped()
                    }
                }
                
                let alertTitle = Text(title)
                let alertMessage = Text(message)
                
                if let primaryButton = primaryButton,
                   let secondaryButton = secondaryButton {
                    return Alert(title: alertTitle, message: alertMessage, primaryButton: primaryButton, secondaryButton: secondaryButton)
                } else {
                    return Alert(title: alertTitle, message: alertMessage)
                }
            }
        }
    }
    
    func leaveGroupButtonTapped() {
        viewModel.leaveGroupButtonTapped { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Error leaving group: \(error)")
            }
        }
    }
}

// TODO: Move to own files



struct Header: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
    }
}

struct UserField: View {
    
    var fieldName: String
    var value: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 20, content: {
            Text(fieldName)

            Text(value)
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
