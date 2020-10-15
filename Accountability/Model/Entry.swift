//
//  Entry.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/13/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Entry: Codable, Identifiable, Equatable {
    
    @DocumentID var id: String?
    var title: String
    var body: String
    var createdTime: Date
    
    var userId: String?
}

#if DEBUG
let debugEntries: [Entry] = [
    Entry(title: "First Journal", body: "First journal entry", createdTime: Date()),
    Entry(title: "Second Journal", body: "Second journal entry", createdTime: Date()),
    Entry(title: "Third Journal", body: "Third journal entry", createdTime: Date()),
]
#endif
