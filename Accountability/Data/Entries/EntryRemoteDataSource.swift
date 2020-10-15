//
//  EntriesRemoteDataSource.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol EntryDataSource {
    
    func fetchAllEntries(completion: @escaping (Result<[Entry], Error>) -> Void)
    
    func createEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void)
}

final class EntryRemoteDataSource: EntryDataSource {
    
    private let entriesReference: CollectionReference
    
    init() {
        // TODO: Add API mapping
        self.entriesReference = Firestore.firestore().collection("entries")
    }
    
    func fetchAllEntries(completion: @escaping (Result<[Entry], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in EntryRepository")
            return
        }
        
        entriesReference
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let entries: [Entry] = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Entry.self)
                        }
                        catch {
                            completion(.failure(error))
                        }
                        return nil
                    }
                    
                    completion(.success(entries))
                }
        }
    }
    
    func createEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in EntryRepository")
            return
        }
        
        do {
            var addedEntry = entry
            addedEntry.userId = userId
            let _ = try entriesReference.addDocument(from: addedEntry)
            
            completion(.success(()))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func updateEntry(entry: Entry, completion: @escaping (Result<Void, Error>) -> Void) {
        if let entryID = entry.id {
            do {
                try entriesReference.document(entryID).setData(from: entry)
                
                completion(.success(()))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
}
