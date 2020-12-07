//
//  DecrementGoalTimesThisWeekUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class DecrementGoalTimesThisWeekUseCase: VoidResponseUseCase {
    
    typealias Request = DecrementGoalRequestModel
    
    let goalRepository: GoalRepository
    
    init(goalRepository: GoalRepository) {
        self.goalRepository = goalRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        goalRepository.decrementGoalTimesThisWeek(requestModel: request) { result in
            completion(result)
        }
    }
}
