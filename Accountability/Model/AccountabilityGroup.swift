//
//  Group.swift
//  
//
//  Created by Christopher Grayston on 11/11/20.
//

import Foundation
import FirebaseFirestoreSwift

struct AccountabilityGroup: Identifiable, Codable {

    @DocumentID var id: String?
    var name: String
    var members: [String: Bool] // [userId: isActive]
    var groupId: String
    var adminId: String
}
