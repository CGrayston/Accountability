//
//  LeaveGroupUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class LeaveGroupUseCase: VoidUseCase {
            
    let groupRepository: GroupRepository
    let userRepository: UserRepository
    
    init(groupRepository: GroupRepository, userRepository: UserRepository) {
        self.groupRepository = groupRepository
        self.userRepository = userRepository
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.removeGroupId { [self] result in
            switch result {
            case .success(let groupId):
                groupRepository.leaveGroup(groupId: groupId) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
