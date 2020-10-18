//
//  LogOutUserUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 9/6/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class LogOutUserUseCase: VoidUseCase {
        
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.logOutUser { result in
            completion(result)
        }
    }
}
