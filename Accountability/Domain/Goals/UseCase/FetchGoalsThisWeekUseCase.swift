//
//  FetchAllGoalsUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchGoalsThisWeekUseCase: VoidRequestUseCase {
    
    typealias Response = [Goal]
    
    let goalRepository: GoalRepository
    let userRepository: UserRepository
    
    let goalsTemplateToErrorMapper: GoalsTemplateToErrorMapper
    
    init(goalRepository: GoalRepository, userRepository: UserRepository, goalsTemplateToErrorMapper: GoalsTemplateToErrorMapper) {
        self.goalRepository = goalRepository
        self.userRepository = userRepository
        self.goalsTemplateToErrorMapper = goalsTemplateToErrorMapper
    }
    
//    func execute(completion: @escaping (Result<Response, Error>) -> Void) {
//        goalRepository.fetchGoalsThisWeek { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let goals):
//                // Successfully returned goal(s) for this week
//                completion(.success(goals))
//            case .failure(let error):
//                if case GoalDataError.noGoalDataThisWeek = error {
//                    // No goal data this week -> Query for goal template
//                    self.userRepository.fetchGoalsTemplate { result in
//                        switch result {
//                        case .success(let goalsTemplate):
//                            // Succesfully return goalsTemplate with no error
//                            let error = self.goalsTemplateToErrorMapper.toError(goalsTemplate)
//                            completion(.failure(error))
//                        case .failure(let error):
//                            completion(.failure(error))
//                        }
//                    }
//                } else {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
    
    
    func execute(completion: @escaping (Result<Response, Error>) -> Void) {
        goalRepository.fetchGoalsThisWeek { [weak self] result in
            completion(result)
        }
    }
}
