//
//  GoalRemoteDataSource.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol GoalDataSource {
    
    func fetchAllGoals(completion: @escaping (Result<[Goal], Error>) -> Void)
    
    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateGoal(requestModel: UpdateGoalRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func incrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func decrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class GoalRemoteDataSource: GoalDataSource {
    
    private let goalsReference: CollectionReference
    
    init() {
        // TODO: Add API mapping
        self.goalsReference = Firestore.firestore().collection("goals")
    }
    
    func fetchAllGoals(completion: @escaping (Result<[Goal], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in GoalRepository")
            return
        }
        
        goalsReference
            .order(by: "weekStart")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let goals: [Goal] = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Goal.self)
                        }
                        catch {
                            completion(.failure(error))
                        }
                        return nil
                    }
                    
                    completion(.success(goals))
                }
        }
    }
    
    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in GoalRepository")
            return
        }

        do {
            var addedGoal = goal
            addedGoal.userId = userId
            let _ = try goalsReference.addDocument(from: addedGoal)

            completion(.success(()))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func updateGoal(requestModel: UpdateGoalRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let goalId = requestModel.goalId
        goalsReference.document(goalId).updateData([
            "title": requestModel.newTitle,
            "timesPerWeek": requestModel.timesPerWeek,
        ], completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        goalsReference.document(goalId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func incrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        goalsReference.document(goalId).updateData([
            "timesThisWeek": FieldValue.increment(Int64(1))
        ], completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
    
    func decrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        goalsReference.document(goalId).updateData([
            "timesThisWeek": FieldValue.increment(Int64(-1))
        ], completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
}
