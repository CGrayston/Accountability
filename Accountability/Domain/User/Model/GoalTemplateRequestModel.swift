//
//  GoalTemplateRequestModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/15/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

struct GoalTemplateRequestModel {
    let title: String
    let timesPerWeek: Int
}

// TODO: Move to own file
struct UpdateGoalTemplateRequestModel {
    let newTitle: String
    let originalTitle: String
    let timesPerWeek: Int
}
