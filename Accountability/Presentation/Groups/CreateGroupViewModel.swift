//
//  CreateGroupViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class CreateGroupViewModel {
    let createGroupUseCase: CreateGroupUseCase
    
    init(createGroupUseCase: CreateGroupUseCase) {
        self.createGroupUseCase = createGroupUseCase
    }
    
    func createGroupButtonTapped(_ groupName: String, completion: @escaping (Result<String, Error>) -> Void) {
        createGroupUseCase.execute(request: groupName) { result in
            completion(result)
        }
    }
}
