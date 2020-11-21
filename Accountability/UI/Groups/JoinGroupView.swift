//
//  JoinGroupView.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/9/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct JoinGroupView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var textFieldData = ""
    
    let viewModel: JoinGroupViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                Group {
                    TextField("Group Code", text: $textFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical)
                    
                    Button(action: {
                        // TODO: JoinGroup Use Case
                        viewModel.joinGroupWithCode(textFieldData) { result in
                            switch result {
                            case .success:
                                // TODO: Dismiss
                                presentationMode.wrappedValue.dismiss()
                                break
                            case .failure(let error):
                                // TODO: Show appropriate error alert
                                break
                            }
                        }
                    }, label: {
                        VStack {
                            Text("Join Group")
                                .font(.body)
                                .fontWeight(.heavy)
                                .frame(width: geometry.size.width * 0.8, height: 30, alignment: .center)
                                .padding(8)
                                .foregroundColor(Color.white)
                                .background(Color.secondary)
                                .cornerRadius(8)
                            
                        }
                    })
                }
            }
            .font(.title)
            .padding(.horizontal)
        }
        .navigationBarTitle("Join Group", displayMode: .large)
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

struct JoinGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let joinGroupUseCase = UseCaseProvider().joinGroupUseCase
        let viewModel = JoinGroupViewModel(joinGroupUseCase: joinGroupUseCase)
        JoinGroupView(viewModel: viewModel)
    }
}
