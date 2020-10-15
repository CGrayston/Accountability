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
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func logOutUser(completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserRemoteDataSource: UserDataSource {

    private let usersReference: CollectionReference
    
    init() {
        // TODO: Add API mapping
        self.usersReference = Firestore.firestore().collection("users")
    }
    
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
        // Check if username is unique
        let username = usersReference.whereField("username", isEqualTo: user.username)
        username.getDocuments { [weak self] (querySnapshot, error) in
            if let querySnapshot = querySnapshot,
               querySnapshot.documents.count > 0 {
                completion(.failure(UserDataError.duplicateUsername))
            } else {
                // Create new user
                do {
                    let _ = try self?.usersReference.document(user.userId).setData(from: user)
                    completion(.success(()))
                }
                catch {
                    completion(.failure(error))
                }
            }
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
}

enum UserDataError: Error {
    case fetching
    case noUser
    case duplicateUsername
    case notAuthenticated
    case noRequestUserId
    case unknown
}
