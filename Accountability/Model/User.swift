//
//  User.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var name: String
    var username: String
    var email: String
    var dateCreated: Date
    var userId: String
    var goalsTemplate: [String: Int]?
    
    // TODO: Make sure this is the name we want and if we want it to be nil
    var groupId: String?
}
