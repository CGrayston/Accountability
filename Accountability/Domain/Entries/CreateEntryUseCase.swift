//
//  CreateNewEntryUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

// TODO: Implement this with user inpu
class CreateEntryUseCase: VoidResponseUseCase {
    
    typealias Request = Entry
    
    let entryRepository: EntryRepository
    
    init(entryRepository: EntryRepository) {
        self.entryRepository = entryRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        entryRepository.createEntry(entry: request) { result in
            completion(result)
        }
    }
}
