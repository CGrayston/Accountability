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
    
    @DocumentID var id: String?
    var title: String
    var timesThisWeek: Int
    var timesPerWeek: Int
    var weekStart: Date
    var weekEnd: Date
    
    var userId: String?
}


//#if DEBUG
//let debugGoals: [Goal] = [
//    Goal(id: "1234", title: "Drink water", timesThisWeek: 2, timesPerWeek: 7, weekStart: Date(), weekEnd: Date()),
//    Goal(id: "5648", title: "Run", timesThisWeek: 1, timesPerWeek: 3, weekStart: Date(), weekEnd: Date()),
//    Goal(id: "9101", title: "Bike", timesThisWeek: 1, timesPerWeek: 4, weekStart: Date(), weekEnd: Date()),
//    Goal(id: "1213", title: "Meal Prep", timesThisWeek: 0, timesPerWeek: 1, weekStart: Date(), weekEnd: Date()),
//]
//#endif
