//
//  FetchAllEntriesUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchAllEntriesUseCase: VoidRequestUseCase {
    
    typealias Response = [Entry]
    
    let entryRepository: EntryRepository
    
    init(entryRepository: EntryRepository) {
        self.entryRepository = entryRepository
    }
    
    func execute(completion: @escaping (Result<Response, Error>) -> Void) {
        entryRepository.fetchAllEntries { result in
            completion(result)
        }
    }
}
