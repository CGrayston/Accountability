//
//  FetchGroupMemberNamesUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchGroupMemberNamesUseCase: UseCase {
    
    typealias Request = [String]
    typealias Response = [String: String]
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(request: [String], completion: @escaping (Result<[String : String], Error>) -> Void) {
        userRepository.fetchGroupMemberNames(memberIds: request) { result in
            completion(result)
        }
    }
}
