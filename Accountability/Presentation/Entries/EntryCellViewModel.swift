//
//  EntryCellViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

// Observe any changes we make to properties in this view models
class EntryCellViewModel: ObservableObject, Identifiable {
    @Published var entryRepository = EntryRepository()
    
    @Published var entry: Entry
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(entry: Entry) {
        self.entry = entry
        
//        $entry
//            .map { entry in
//                entry.completed ? "checkmark.circle.fill" : "circle"
//        }
//        .assign(to: \.completionStateIconName, on: self)
//        .store(in: &cancellables)
        
        $entry
            .compactMap { entry in
                entry.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
//        $entry
//            .dropFirst()
//            // Only send updates 0.8 seconds after you are done typing
//            .debounce(for: 0.8, scheduler: RunLoop.main)
//            .sink { entry in
//                self.entryRepository.updateEntry(entry)
//        }
//        .store(in: &cancellables)
    }
}
