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

    @Published var entryCellViewModels = [EntryCellViewModel]()
    @Published var entries = [Entry]()
    
    private let fetchAllEntriesUseCase = UseCaseProvider().fetchAllEntriesUseCase
    private let createEntryUseCase = UseCaseProvider().createEntryUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchAllEntries()
    }
    
    func fetchAllEntries() {
        fetchAllEntriesUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let entries):
                self.entries = entries
                
                self.$entries
                    .map { entries in
                        entries.map { entry in
                            EntryCellViewModel(entry: entry)
                        }
                }
                .assign(to: \.entryCellViewModels, on : self)
                .store(in: &self.cancellables)
                
            case .failure(let error):
                fatalError("TODO: Handle error here \(error.localizedDescription)")
            }
        }
    }
    
    func createNewEntry(_ entry: Entry) {
        createEntryUseCase.execute(request: entry) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
