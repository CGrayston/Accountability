//
//  TaskRemoteDataSource.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/19/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TaskDataSource {
    
    func fetchAllTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    
    func addTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TaskRemoteDataSource: TaskDataSource {
    
    private let tasksReference: CollectionReference
    
    init() {
        // TODO: Add API mapping
        self.tasksReference = Firestore.firestore().collection("tasks")
    }
    
    func fetchAllTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in TaskRepository")
            return
        }
        
        tasksReference
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let tasks: [Task] = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Task.self)
                        }
                        catch {
                            completion(.failure(error))
                        }
                        return nil
                    }
                    
                    completion(.success(tasks))
                }
        }
    }
    
    func addTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in TaskRepository")
            return
        }
        
        do {
            var addedTask = task
            addedTask.userId = userId
            let _ = try tasksReference.addDocument(from: addedTask)
            
            completion(.success(()))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func updateTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        if let taskID = task.id {
            do {
                try tasksReference.document(taskID).setData(from: task)
                
                completion(.success(()))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
}
