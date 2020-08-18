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
    
    var onCommit: (Entry) -> () = { _ in }
        
    var body: some View {
        VStack {
            TextField("Enter title", text: $viewModel.entry.title, onCommit: {
                self.onCommit(self.viewModel.entry)
            })
            
            TextField("Entry body", text: $viewModel.entry.body, onCommit: {
                self.onCommit(self.viewModel.entry)
            })
        }
        
        .navigationBarTitle("\(viewModel.entry.createdTime.fullTimeNoneFormatter())", displayMode: .inline)
        .font(.body)
    }
}

struct EntryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EntryEditorView(viewModel: EntryEditorViewModel(entry: mockEntry))
    }
}

#if DEBUG
let mockEntry = Entry(title: "First Entry Title", body: "First entry body", createdTime: Date(), userId: "1234")
#endif
