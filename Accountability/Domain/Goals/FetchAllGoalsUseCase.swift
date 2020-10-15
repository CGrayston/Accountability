//
//  FetchAllGoalsUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchAllGoalsUseCase: VoidRequestUseCase {
    
    typealias Response = [Goal]
    
    let goalRepository: GoalRepository
    
    init(goalRepository: GoalRepository) {
        self.goalRepository = goalRepository
    }
    
    func execute(completion: @escaping (Result<Response, Error>) -> Void) {
        goalRepository.fetchAllGoals { result in
            completion(result)
        }
    }
}
