//
//  FetchUserUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchUserUseCase: VoidRequestUseCase {

    typealias Response = User
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(completion: @escaping (Result<User, Error>) -> Void) {
        userRepository.fetchUser { result in
            completion(result)
        }
    }
}
