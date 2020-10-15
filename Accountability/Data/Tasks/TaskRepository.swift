//
//  TaskRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/5/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol TaskRepository {
    
    func fetchAllTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    
    func addTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TaskDataRepository: TaskRepository {
    
    let remoteDataSource: TaskDataSource
    
    init(remoteDataSource: TaskDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchAllTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        remoteDataSource.fetchAllTasks { result in
            completion(result)
        }
    }
    
    func addTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.addTask(task: task) { result in
            completion(result)
        }
    }
    
    func updateTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.updateTask(task: task) { result in
            completion(result)
        }
    }
}


