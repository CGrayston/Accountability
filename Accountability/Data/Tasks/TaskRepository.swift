//
//  TaskRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/5/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var tasks = [Task]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in TaskRepository")
            return
        }
        
        db.collection("tasks")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Task.self)
                        }
                        catch {
                            print(error)
                        }
                        return nil
                    }
                }
        }
    }
    
    func addTask(_ task: Task) {
        do {
            var addedTask = task
            let userId = Auth.auth().currentUser?.uid
            addedTask.userId = userId
            let _ = try db.collection("tasks").addDocument(from: addedTask)
        }
        catch {
            fatalError("Unable to encode task on add: \(error.localizedDescription)")
        }
    }
    
    func updateTask(_ task: Task) {
        if let taskID = task.id {
            do {
                try db.collection("tasks").document(taskID).setData(from: task)
            }
            catch {
                fatalError("Unable to encode task on update: \(error.localizedDescription)")
            }
        }
    }
}


