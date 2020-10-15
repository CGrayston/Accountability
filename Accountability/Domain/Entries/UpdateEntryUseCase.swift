//
//  UpdateEntryUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/19/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class UpdateEntryUseCase: VoidResponseUseCase {
    
    typealias Request = Entry
    
    let entryRepository: EntryRepository
    
    init(entryRepository: EntryRepository) {
        self.entryRepository = entryRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        entryRepository.updateEntry(entry: request) { result in
            completion(result)
        }
    }
}
