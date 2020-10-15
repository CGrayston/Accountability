//
//  UpdateTaskUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/19/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class UpdateTaskUseCase: VoidResponseUseCase {
    
    typealias Request = Task
    
    let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        taskRepository.updateTask(task: request) { result in
            completion(result)
        }
    }
}
