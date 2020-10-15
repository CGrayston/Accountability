//
//  UpdateGoalUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class UpdateGoalUseCase: VoidResponseUseCase {
    
    typealias Request = Goal
    
    let goalRepository: GoalRepository
    
    init(goalRepository: GoalRepository) {
        self.goalRepository = goalRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        goalRepository.updateGoal(goal: request) { result in
            completion(result)
        }
    }
}
