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

struct Entry: Codable, Identifiable {
    var title: String
    var body: String
    
    @DocumentID var id: String?
    @ServerTimestamp var createdTime: Timestamp?
}

#if DEBUG
let entries: [Entry] = [
    Entry(title: "First Journal", body: "First journal entry"),
    Entry(title: "Second Journal", body: "Second journal entry"),
    Entry(title: "Third Journal", body: "Third journal entry"),
]
#endif
