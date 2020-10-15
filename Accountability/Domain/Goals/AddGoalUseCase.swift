//
//  AddGoalUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/7/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class AddGoalUseCase: VoidResponseUseCase {
    
    typealias Request = Goal
    
    let goalRepository: GoalRepository
    
    init(goalRepository: GoalRepository) {
        self.goalRepository = goalRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        goalRepository.addGoal(goal: request) { result in
            completion(result)
        }
    }
}
