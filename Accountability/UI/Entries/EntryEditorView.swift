//
//  EntryEditorView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/15/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct EntryEditorView: View {
    @ObservedObject var viewModel: EntryEditorViewModel
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 8) {
            TextField("Enter title", text: $viewModel.entry.title)
                .font(.title)
            
            if #available(iOS 14.0, *) {
                TextEditor(text: $viewModel.entry.body)
            } else {
                // TODO: - Implement Custom View for iOS 13 and below
                TextField("TODO: Make custom textView", text: $viewModel.entry.body)
            }
        }
        .navigationBarTitle("\(viewModel.entry.createdTime.fullTimeNoneFormatter())", displayMode: .inline)
        .padding(.horizontal)
    }
}

struct EntryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let mockEntry = Entry(title: "First Entry Title", body: "First entry body", createdTime: Date(), userId: "1234")
        let viewModel = EntryEditorViewModel(entry: mockEntry)
        
        EntryEditorView(viewModel: viewModel)
            .previewDevice("iPhone 11")
    }
}
