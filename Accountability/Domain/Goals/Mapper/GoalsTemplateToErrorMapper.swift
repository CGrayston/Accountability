//
//  GoalsTemplateToErrorMapper.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/19/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class GoalsTemplateToErrorMapper {
    func toError(_ goalsTemplate: [String : Int]?) -> Error {
        if goalsTemplate == nil {
            return GoalsDomainError.noGoalsNilTemplate
        } else if goalsTemplate?.isEmpty == true {
             return GoalsDomainError.noGoalsEmptyTemplate
        } else  {
            return GoalsDomainError.noGoalsHasTemplate
        }
    }
}
