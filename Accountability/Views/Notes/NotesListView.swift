//
//  NotesListView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct NotesListView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(entries) { entry in
                        Text("\(entry.title)")
                    }
                }
                .navigationBarTitle("Notes")
            }
        }
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView()
    }
}


