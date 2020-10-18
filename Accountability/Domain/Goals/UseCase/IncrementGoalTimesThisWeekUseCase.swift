//
//  IncrementGoalTimesThisWeekUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class IncrementGoalTimesThisWeekUseCase: VoidResponseUseCase {
    
    typealias Request = String
    
    let goalRepository: GoalRepository
    
    init(goalRepository: GoalRepository) {
        self.goalRepository = goalRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        goalRepository.incrementGoalTimesThisWeek(goalId: request) { result in
            completion(result)
        }
    }
}
