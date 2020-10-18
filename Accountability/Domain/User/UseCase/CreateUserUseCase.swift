//
//  CreateUserUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class CreateUserUseCase: VoidResponseUseCase {
    
    typealias Request = User
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.createUser(user: request) { result in
            completion(result)
        }
    }
}
