//
//  CreateGroupView.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/9/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct CreateGroupView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var textFieldData = ""
    
    @State var showingAlert: Bool = false
    @State var textCopied: Bool = false

    let viewModel: CreateGroupViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                Group {
                    TextField("Enter Group Name", text: $textFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical)
                    
                    if textFieldData.isEmpty == false {
                        Button(action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = textFieldData
                            textCopied = true
                        }) {
                            Label(textCopied ? "Text copied" :  "Click to copy group code", systemImage: "doc.on.doc.fill")
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button(action: {
                        showingAlert.toggle()
                    }, label: {
                            Text("Create Accountability Group")
                                .font(.body)
                                .fontWeight(.heavy)
                                .frame(width: geometry.size.width * 0.8, height: 30, alignment: .center)
                                .padding(8)
                                .foregroundColor(Color.white)
                                .background(Color.secondary)
                                .cornerRadius(8)
                    })
                    .disabled(textFieldData.isEmpty)
                }
            }
            .font(.title)
            .padding(.horizontal)
        }
        .alert(isPresented: $showingAlert) {
            let title = Text("Create Group?")
            let message = Text("This will create a group code to share with your friends where you can track your weekly progress together.")
            let primaryButton = Alert.Button.default(Text("Cancel"))
            let secondaryButton = Alert.Button.default(Text("Create")) {
                viewModel.createGroupButtonTapped(textFieldData) { result in
                    switch result {
                    case .success(let groupCode):
                        // TODO: Handle this
                        print(groupCode)
                    case .failure(let error):
                        // TODO: handle this
                        print(error)
                    }
                }
                showingAlert = false
            }
                        
            return Alert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        .navigationBarTitle("Create Group", displayMode: .large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.red)
                })
        )
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let createGroupUseCase = UseCaseProvider().createGroupUseCase
        let viewModel = CreateGroupViewModel(createGroupUseCase: createGroupUseCase)
        CreateGroupView(viewModel: viewModel)
    }
}
