//
//  CreateThisWeeksGoalsFromTemplate.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/30/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class CreateThisWeeksGoalsFromTemplateUseCase: VoidUseCase {
        
    let goalRepository: GoalRepository
    let userRepository: UserRepository
        
    init(goalRepository: GoalRepository, userRepository: UserRepository) {
        self.goalRepository = goalRepository
        self.userRepository = userRepository
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.fetchGoalsTemplate { [self] result in
            switch result {
            case .success(let goalsTemplate):
                guard let goalsTemplate = goalsTemplate else {
                    completion(.failure(GoalsDomainError.nilGoalsTemplate))
                    return
                }
                
                if goalsTemplate.count == 0 {
                    completion(.failure(GoalsDomainError.noGoalsNilTemplate))
                    return
                }
                
                goalRepository.createThisWeeksGoalsFromTemplate(goalsTemplate: goalsTemplate) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// TODO: Move to own class if end up making goal template
import FirebaseFirestore
import FirebaseFirestoreSwift

struct GoalTemplateResponse {
    @DocumentID var goalTemplateUID: String?
    let title: String
    let timesPerWeek: Int
    
    let type: GoalType
}

enum GoalType {
    case weekly
    case daily
    case custom
}
