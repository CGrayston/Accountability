//
//  UserRemoteDataSource.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserDataSource {
    
    // MARK: - User CRUD Methods

    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func logOutUser(completion: @escaping (Result<Void, Error>) -> Void)
    
    // MARK: - Goal Template CRUD Methods

    func fetchGoalsTemplate(completion: @escaping (Result<[String: Int]?, Error>) -> Void)
    
    func addGoalTemplateEntry(request: GoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateGoalTemplateEntry(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteGoalTemplateEntry(goalTitle: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func clearGoalsTemplate(completion: @escaping (Result<Void, Error>) -> Void)
    
    // MARK: - Group CRUD Methods
    
    func addGroupId(groupId: String, completion: @escaping (Result<Void, Error>) -> Void)

    func removeGroupId(completion: @escaping (Result<String, Error>) -> Void)
    
    // MARK: - Name/Title Verification Methods

    func isUniqueUserName(username: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func isValidNewGoalTitle(newTitle: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func isValidUpdatedGoalTitle(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserRemoteDataSource: UserDataSource {

    private let usersReference: CollectionReference
    
    init() {
        // TODO: Add API mapping
        self.usersReference = Firestore.firestore().collection("users")
    }
    
    // MARK: - User CRUD Methods
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let document = documentSnapshot else {
                        completion(.failure(UserDataError.fetching))
                        return
                    }
                    
                    guard let user = try? document.data(as: User.self) else {
                        completion(.failure(UserDataError.noUser))
                        return
                    }
                    
                    completion(.success(user))
                }
            }
    }
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try usersReference.document(user.userId).setData(from: user)
            completion(.success(()))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func updateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check if username is unique
        let username = usersReference.whereField("username", isEqualTo: user.username)
        username.getDocuments { [weak self] (querySnapshot, error) in
            if let querySnapshot = querySnapshot,
               querySnapshot.documents.count > 0 {
                completion(.failure(UserDataError.duplicateUsername))
            } else {
                // Update user
                if let userID = user.id {
                    do {
                        try self?.usersReference.document(userID).setData(from: user)
                        completion(.success(()))
                    }
                    catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(UserDataError.noRequestUserId))
                }
            }
        }
    }
    
    func logOutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let firebaseAuth = Auth.auth()
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Goal Template CRUD Methods
    
    func fetchGoalsTemplate(completion: @escaping (Result<[String: Int]?, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).getDocument(completion: { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let user = try? document.data(as: User.self) else {
                    completion(.failure(UserDataError.noUser))
                    return
                }
                
                completion(.success(user.goalsTemplate))
            }
        })
    }

    func addGoalTemplateEntry(request: GoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        let data = ["goalsTemplate": [request.title: request.timesPerWeek]]
        
        usersReference.document(userId).setData(data, merge: true, completion: { error in
            if let error = error {
                completion(.failure(error))
            }
            
            completion(.success(()))
        })
    }
    
    func updateGoalTemplateEntry(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        // We know there is a valid goal that we have already updated so update here
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).getDocument(completion: { [weak self] documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let user = try? document.data(as: User.self) else {
                    completion(.failure(UserDataError.noUser))
                    return
                }
                
                let oldKey = requestModel.originalTitle
                let newKey = requestModel.newTitle
                let newValue = requestModel.timesPerWeek
                
                // Update value for old key and save it to Firestore
                if var goalsTemplate = user.goalsTemplate {
                    goalsTemplate.removeValue(forKey: oldKey)
                    goalsTemplate[newKey] = newValue
                    
                    self?.usersReference.document(userId).updateData([
                        "goalsTemplate": goalsTemplate,
                    ], completion: { error in
                        if let error = error {
                            completion(.failure(error))
                        }
                        
                        completion(.success(()))
                    })
                }
            }
        })
    }
    
    func deleteGoalTemplateEntry(goalTitle: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).getDocument(completion: { [weak self] documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let user = try? document.data(as: User.self) else {
                    completion(.failure(UserDataError.noUser))
                    return
                }
                
                // Check if new name is contained as a key in goalTemplate
                if var goalsTemplate = user.goalsTemplate,
                   let _ = goalsTemplate.removeValue(forKey: goalTitle) {
                    self?.usersReference.document(userId).updateData([
                        "goalsTemplate": goalsTemplate,
                    ], completion: { error in
                        if let error = error {
                            completion(.failure(error))
                        }
                        
                        completion(.success(()))
                    })
                }
            }
        })
    }
    
    func clearGoalsTemplate(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).updateData([
            "goalsTemplate": [:],
        ], completion: { error in
            if let error = error {
                completion(.failure(error))
            }
            
            completion(.success(()))
        })
    }

    // MARK: - Group CRUD Methods
    
    func addGroupId(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Add groupId to user
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).updateData([
            "groupId": groupId,
        ]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    func removeGroupId(completion: @escaping (Result<String, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).getDocument(completion: { [weak self] documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let user = try? document.data(as: User.self) else {
                    completion(.failure(UserDataError.noUser))
                    return
                }
                
                guard let goalsTemplate = user.groupId else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                self?.usersReference.document(userId).updateData([
                    "groupId": FieldValue.delete(),
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(goalsTemplate))
                }
            }
        })
    }
    
    // TODO
    
    // MARK: - Name/Title Verification Methods
    
    func isUniqueUserName(username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check if username is unique
        let usernameReference = usersReference.whereField("username", isEqualTo: username)
        usernameReference.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot,
               querySnapshot.documents.count > 0 {
                completion(.failure(UserDataError.duplicateUsername))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func isValidNewGoalTitle(newTitle: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).getDocument(completion: { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let user = try? document.data(as: User.self) else {
                    completion(.failure(UserDataError.noUser))
                    return
                }
                
                // Check if new name is contained as a key in goalTemplate
                if let goalTemplate = user.goalsTemplate {
                    for (key, _) in goalTemplate {
                        if key.lowercased() == newTitle.lowercased() {
                            completion(.failure(UserDataError.duplicateGoalTitle))
                            return
                        }
                    }
                }
                
                completion(.success(()))
            }
        })
    }
    
    func isValidUpdatedGoalTitle(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(UserDataError.notAuthenticated))
            return
        }
        
        usersReference.document(userId).getDocument(completion: { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let user = try? document.data(as: User.self) else {
                    completion(.failure(UserDataError.noUser))
                    return
                }
                
                // Check if newTitle is equal to any existing keys and not just the existing title
                if let goalTemplate = user.goalsTemplate {
                    for (key, _) in goalTemplate {
                        if key.lowercased() == requestModel.newTitle.lowercased() &&
                            key.lowercased().lowercased() != requestModel.originalTitle.lowercased() {
                            completion(.failure(UserDataError.duplicateGoalTitle))
                            return
                        }
                    }
                }
                
                completion(.success(()))
            }
        })
    }
}

enum UserDataError: Error {
    case fetching
    case noUser
    case duplicateUsername
    case duplicateGoalTitle
    case notAuthenticated
    case noRequestUserId
    case unknown
}
