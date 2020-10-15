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
    
    @Published var entry: Entry
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(entry: Entry) {
        self.entry = entry
        
        $entry
            .compactMap { entry in
                entry.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}
