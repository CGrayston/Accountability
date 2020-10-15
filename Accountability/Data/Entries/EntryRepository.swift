//
//  EntryRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol EntryRepository {
    
    func fetchAllEntries(completion: @escaping (Result<[Entry], Error>) -> Void)
    
    func createEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void)
}

final class EntryDataRepository: EntryRepository {
    
    let remoteDataSource: EntryDataSource
    
    init(remoteDataSource: EntryDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchAllEntries(completion: @escaping (Result<[Entry], Error>) -> Void) {
        remoteDataSource.fetchAllEntries { result in
            completion(result)
        }
    }
    
    func createEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.createEntry(entry: entry, completion: { result in
            completion(result)
        })
    }
    
    func updateEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.updateEntry(entry: entry, completion: { result in
            completion(result)
        })
    }
}
