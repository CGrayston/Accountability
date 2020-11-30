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
    
    func fetchGoalsThisWeek(completion: @escaping (Result<[Goal], Error>) -> Void)
    
    func createThisWeeksGoalsFromTemplate(goalsTemplate: [String: Int], completion: @escaping (Result<Void, Error>) -> Void)

    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateGoal(requestModel: UpdateGoalRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func incrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func decrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchGroupGoalsThisWeek(memberIds: [String], completion: @escaping (Result<[Goal], Error>) -> Void)
}

final class GoalRemoteDataSource: GoalDataSource {
    
    private let goalsReference: CollectionReference
    
    init() {
        self.goalsReference = Firestore.firestore().collection("goals")
    }
    
    func fetchGoalsThisWeek(completion: @escaping (Result<[Goal], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
              let startOfWeek = Date().startOfWeek,
              let endOfWeek = Date().endOfWeek else {
            print("No userId or misconfigured Date when attempting to loadData in GoalRepository")
            return
        }
        
        goalsReference
            .order(by: "weekStart")
            .whereField("userId", isEqualTo: userId)
            .whereField("weekStart", isGreaterThanOrEqualTo: startOfWeek)
            .whereField("weekStart", isLessThanOrEqualTo: endOfWeek)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
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
    
    func createThisWeeksGoalsFromTemplate(goalsTemplate: [String: Int], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No userId when attempting to loadData in GoalRepository")
            return
        }
        
        let batch = Firestore.firestore().batch()
        
        let goals = goalsTemplate.map { Goal(id: UUID().uuidString, title: $0.key, timesThisWeek: 0, timesPerWeek: $0.value, weekStart: Date(), weekEnd: Date(), userId: userId) }
                
        for goal in goals {
            do {
                let _ = try batch.setData(from: goal, forDocument: goalsReference.document(goal.id!))
            } catch {
                completion(.failure(error))
            }
        }
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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

// MARK: - Leaderboard Goal Data Source Implementation
extension GoalRemoteDataSource {
    
    func fetchGroupGoalsThisWeek(memberIds: [String], completion: @escaping (Result<[Goal], Error>) -> Void) {
        guard let startOfWeek = Date().startOfWeek,
              let endOfWeek = Date().endOfWeek else {
            fatalError("Date helper class isn't working")
        }
        
        goalsReference
            .whereField("userId", in: memberIds)
            .whereField("weekStart", isGreaterThanOrEqualTo: startOfWeek)
            .whereField("weekStart", isLessThanOrEqualTo: endOfWeek)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
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
}

// TODO: Better error handling
enum GoalDataError: Error {
    case fetching
    case noGoalDataThisWeek
    case unknown
}
