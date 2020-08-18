//
//  EntryEditorViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

class EntryEditorViewModel: ObservableObject, Identifiable {
    @Published var entryRepository = EntryRepository()
    
    @Published var entry: Entry
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(entry: Entry) {
        self.entry = entry
        
        $entry
            .compactMap { task in
                task.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $entry
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { entry in
                self.entryRepository.updateEntry(entry)
        }
        .store(in: &cancellables)
    }
}
