//
//  Task.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/3/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Task: Codable, Identifiable {
    // DocID - tells FB codable that when you are reaidng something form firestor that it should read doc id from firestore for this value
    @DocumentID var id: String?
    var title: String
    var completed: Bool
    
    // When created time is nil will fil in server timestamp
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
}


#if DEBUG
let testDataTasks = [
    Task(title: "Implement the UI", completed: true),
    Task(title: "Conncect to FB", completed: false),
    Task(title: "????", completed: false),
    Task(title: "Profit", completed: false)
]
#endif
