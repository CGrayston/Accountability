//
//  EntryListView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct EntryListView: View {
    
    @ObservedObject var entryListVM = EntryListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(entryListVM.entryCellViewModels) { entryCellVM in
                        NavigationLink(destination:
                        EntryEditorView(viewModel: EntryEditorViewModel(entry: entryCellVM.entry))) {
                            EntryCell(entryCellVM: entryCellVM)
                        }
                    }
                }
                .navigationBarTitle("Notes")
            }
        }
    }
}

struct EntryCell: View {
    @ObservedObject var entryCellVM: EntryCellViewModel
    
    // TODO: Decide if we want this to be editable here
    var onCommit: (Entry) -> () = { _ in }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(entryCellVM.entry.title)
                .font(.title)
            Text(entryCellVM.entry.body)
                .font(.body)
        }
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView()
    }
}
