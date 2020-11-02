//
//  CheckTemplateStatusUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/1/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchTemplateStatusUseCase: VoidRequestUseCase {
        
    typealias Response = TemplateStatus
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(completion: @escaping (Result<TemplateStatus, Error>) -> Void) {
        userRepository.fetchGoalsTemplate { result in
            switch result {
            case .success(let goalsTemplate):
                guard let goalsTemplate = goalsTemplate else {
                    completion(.success(.nilTemplate))
                    return
                }
                
                if goalsTemplate.count == 0 {
                    completion(.success(.emptyTemplate))
                } else if goalsTemplate.count > 0 {
                    completion(.success(.hasTemplate))
                } else {
                    completion(.failure(UserDataError.unknown))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
