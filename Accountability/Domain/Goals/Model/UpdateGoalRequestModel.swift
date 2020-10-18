//
//  UpdateGoalRequestModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/18/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

struct UpdateGoalRequestModel {
    let originalTitle: String
    let newTitle: String
    let timesPerWeek: Int
    let goalId: String
}
