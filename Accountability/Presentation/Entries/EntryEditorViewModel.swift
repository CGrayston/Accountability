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
    
    @Published var entry: Entry
    
    var id = ""
    
    private let updateEntryUseCase = UseCaseProvider().updateEntryUseCase

    private var cancellables = Set<AnyCancellable>()
    
    init(entry: Entry) {
        self.entry = entry
        
        $entry
            .compactMap { entry in
                entry.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $entry
            .dropFirst()
            .debounce(for: 2, scheduler: RunLoop.main)
            .sink { [weak self] entry in
                self?.updateEntry(entry: entry)
        }
        .store(in: &cancellables)
    }
    
    private func updateEntry(entry: Entry) {
        updateEntryUseCase.execute(request: entry) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("Error updating entry: \(error.localizedDescription)")
            }
        }
    }
}
