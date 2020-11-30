//
//  FetchGroupUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchGroupUseCase: VoidRequestUseCase {
    
    typealias Response = AccountabilityGroup?
    
    let groupRepository: GroupRepository
        
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func execute(completion: @escaping (Result<Response, Error>) -> Void) {
        groupRepository.fetchGroup { result in
            completion(result)
        }
    }
}
