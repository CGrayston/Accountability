//
//  FetchAllTasksUseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/19/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class FetchAllTasksUseCase: VoidRequestUseCase {
    
    typealias Response = [Task]
    
    let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func execute(completion: @escaping (Result<Response, Error>) -> Void) {
        taskRepository.fetchAllTasks { result in
            completion(result)
        }
    }
}
