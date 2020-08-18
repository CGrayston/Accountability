//
//  EntryRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class EntryRepository: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var entries = [Entry]()
    
    
    init() {
//        #if DEBUG
//        self.entries = debugEntries
//        #else
        loadData()
        //#endif
    }
    
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in EntryRepository")
            return
        }
        
        db.collection("entries")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.entries = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Entry.self)
                        }
                        catch {
                            print(error)
                        }
                        return nil
                    }
                }
        }
    }
    
    func addEntry(_ entry: Entry) {
        do {
            var addedEntry = entry
            let userId = Auth.auth().currentUser?.uid
            addedEntry.userId = userId
            let _ = try db.collection("entries").addDocument(from: addedEntry)
        }
        catch {
            fatalError("Unable to encode entry on add: \(error.localizedDescription)")
        }
    }
    
    func updateEntry(_ entry: Entry) {
        if let entryID = entry.id {
            do {
                try db.collection("entries").document(entryID).setData(from: entry)
            }
            catch {
                fatalError("Unable to encode entry on update: \(error.localizedDescription)")
            }
        }
    }
}
