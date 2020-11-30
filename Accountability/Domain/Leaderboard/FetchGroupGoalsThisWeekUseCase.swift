//
//  FetchGroupGoalsThisWeekUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchGroupGoalsThisWeekUseCase: UseCase {
    
    typealias Request = [String]
    typealias Response = [Goal]
    
    let goalRepository: GoalRepository
        
    init(goalRepository: GoalRepository) {
        self.goalRepository = goalRepository
    }
    
    func execute(request: [String], completion: @escaping (Result<Response, Error>) -> Void) {
        goalRepository.fetchGroupGoalsThisWeek(memberIds: request) { result in
            completion(result)
        }
    }
}
