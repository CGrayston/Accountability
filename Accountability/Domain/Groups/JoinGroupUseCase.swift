//
//  JoinGroupUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class JoinGroupUseCase: VoidResponseUseCase {
        
    typealias Request = String
    
    let groupRepository: GroupRepository
    let userRepository: UserRepository
    
    init(groupRepository: GroupRepository, userRepository: UserRepository) {
        self.groupRepository = groupRepository
        self.userRepository = userRepository
    }
    
    func execute(request: String, completion: @escaping (Result<Void, Error>) -> Void) {
        groupRepository.joinGroup(groupId: request) { [self] result in
            switch result {
            case .success:
                userRepository.addGroupId(groupId: request) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
