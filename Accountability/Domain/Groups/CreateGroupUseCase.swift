//
//  CreateGroupUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class CreateGroupUseCase: UseCase {
    
    typealias Request = String
    typealias Response = String
    
    let groupRepository: GroupRepository
    let userRepository: UserRepository
    
    init(groupRepository: GroupRepository, userRepository: UserRepository) {
        self.groupRepository = groupRepository
        self.userRepository = userRepository
    }
    
    func execute(request: String, completion: @escaping (Result<String, Error>) -> Void) {
        groupRepository.createGroup(name: request) { [self] result in
            switch result {
            case .success(let groupId):
                userRepository.addGroupId(groupId: groupId) { result in
                    switch result {
                    case .success:
                        completion(.success(groupId))
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
