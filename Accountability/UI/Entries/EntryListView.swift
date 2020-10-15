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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    List {
                        ForEach(entryListVM.entryCellViewModels) { entryCellVM in
                            EntryCell(entryCellVM: entryCellVM)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        let entry = Entry(title: "New Journal", body: "", createdTime: Date())
                        entryListVM.createNewEntry(entry)
                    }) {
                        ZStack {
                            Circle().fill()
                                .frame(width: 48, height: 48)
                                .foregroundColor(colorScheme == .light ? .white : .black)
                            
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .opacity(1.0)
                                .frame(width: 48, height: 48)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 20))
                }
            }
            .navigationBarTitle("Journal Entries")
        }
    }
}

struct EntryCell: View {
    
    @ObservedObject var entryCellVM: EntryCellViewModel
        
    var body: some View {
        NavigationLink(destination: EntryEditorView(viewModel: EntryEditorViewModel(entry: entryCellVM.entry))) {
            VStack(alignment: .leading, spacing: 20) {
                Text(entryCellVM.entry.title)
                    .font(.title)
                Text(entryCellVM.entry.body)
                    .font(.body)
            }
        }
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView()
    }
}
