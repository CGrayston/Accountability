//
//  EntryListViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

class EntryListViewModel: ObservableObject {
    @Published var entryRepository = EntryRepository()
    @Published var entryCellViewModels = [EntryCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        entryRepository.$entries
            .map { entries in
                // TODO UseCase intermediate
                entries.map { entry in
                    EntryCellViewModel(entry: entry)
                }
        }
        .assign(to: \.entryCellViewModels, on : self)
        .store(in: &cancellables)
    }
}
