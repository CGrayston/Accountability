//
//  DeleteGoalUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/12/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class DeleteGoalUseCase: VoidResponseUseCase {
    
    typealias Request = DeleteGoalRequestModel
    
    let goalRepository: GoalRepository
    let userRepository: UserRepository
    
    init(goalRepository: GoalRepository, userRepository: UserRepository) {
        self.goalRepository = goalRepository
        self.userRepository = userRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        self.userRepository.deleteGoalTemplateEntry(goalTitle: request.goalTitle) { result in
            // If goal template deleted successfully then we delete the goal
            switch result {
            case .success:
                self.goalRepository.deleteGoal(goalId: request.goalId) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
