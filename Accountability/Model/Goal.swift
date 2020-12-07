//
//  Goal.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct Goal: Identifiable, Codable, Equatable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    var title: String
    var timesThisWeek: Int
    var timesPerWeek: Int
    var weekStart: Date
    var weekEnd: Date
    var completions: [TimeInterval]?
    
    var userId: String?
}
