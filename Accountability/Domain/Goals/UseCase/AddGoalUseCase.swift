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
    let userRepository: UserRepository
    
    init(goalRepository: GoalRepository, userRepository: UserRepository) {
        self.goalRepository = goalRepository
        self.userRepository = userRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check if new goal title is a duplicate
        userRepository.isValidNewGoalTitle(newTitle: request.title) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Not a duplicate title so we add the new goal
                self.goalRepository.addGoal(goal: request) { result in
                    switch result {
                    case .success:
                        // Goal was succesfully added so now we add the goalTemplate entry to User
                        let requestModel = GoalTemplateRequestModel(title: request.title, timesPerWeek: request.timesPerWeek)
                        self.userRepository.addGoalTemplateEntry(request: requestModel) { result in
                            completion(result)
                        }
                    case .failure(let error):
                        // Goal was not succesfully added
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
