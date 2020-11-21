//
//  JoinGroupViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class JoinGroupViewModel {
    let joinGroupUseCase: JoinGroupUseCase
    
    init(joinGroupUseCase: JoinGroupUseCase) {
        self.joinGroupUseCase = joinGroupUseCase
    }
    
    func joinGroupWithCode(_ groupCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        joinGroupUseCase.execute(request: groupCode) { result in
            completion(result)
        }
    }
}
