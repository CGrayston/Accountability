//
//  UpdateGoalUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class UpdateGoalUseCase: VoidResponseUseCase {
    
    typealias Request = UpdateGoalRequestModel
    
    let goalRepository: GoalRepository
    let userRepository: UserRepository
    
    init(goalRepository: GoalRepository, userRepository: UserRepository) {
        self.goalRepository = goalRepository
        self.userRepository = userRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        let newTitle = request.newTitle
        let originalTitle = request.originalTitle
        let timesPerWeek = request.timesPerWeek
        let goalId = request.goalId
        
        // If titles are the same
        if newTitle == originalTitle ||
            newTitle.lowercased() == originalTitle.lowercased() {
            // Skip ifValidName and Update Goal
            goalRepository.updateGoal(requestModel: request) { [weak self] result in
                switch result {
                case .success:
                    // Update goal template
                    let requestModel = UpdateGoalTemplateRequestModel(newTitle: newTitle, originalTitle: originalTitle, timesPerWeek: timesPerWeek)
                    self?.userRepository.updateGoalTemplateEntry(requestModel: requestModel) { result in
                        completion(result)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // Completely new name
            let updateGoalTemplateRequestModel = UpdateGoalTemplateRequestModel(newTitle: newTitle, originalTitle: originalTitle, timesPerWeek: timesPerWeek)
            userRepository.isValidUpdatedGoalTitle(requestModel: updateGoalTemplateRequestModel) { [weak self] result in
                switch result {
                case .success:
                    // Is a valid goal name so we update goal
                    let updateGoalRequestModel = UpdateGoalRequestModel(originalTitle: originalTitle, newTitle: newTitle, timesPerWeek: timesPerWeek, goalId: goalId)
                    
                    self?.goalRepository.updateGoal(requestModel: updateGoalRequestModel) { result in
                        switch result {
                        case .success:
                            // Succesfully updated goal so now we update our goal template
                            self?.userRepository.updateGoalTemplateEntry(requestModel: updateGoalTemplateRequestModel) { result in
                                completion(result)
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
