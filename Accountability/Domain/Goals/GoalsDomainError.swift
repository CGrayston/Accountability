//
//  GoalsDomainError.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/30/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

enum GoalsDomainError: Error {
    case nilGoalsTemplate
    case noGoalsNilTemplate
    case noGoalsEmptyTemplate
    case noGoalsHasTemplate
    case unknown
}
