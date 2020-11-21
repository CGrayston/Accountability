//
//  GroupRemoteDataSource.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol GroupDataSource {
    
    func joinGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void)

    func createGroup(name: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func leaveGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) 
}

final class GroupRemoteDataSource: GroupDataSource {

    private let groupsReference: CollectionReference
    
    init() {
        // TODO: Add API mapping
        self.groupsReference = Firestore.firestore().collection("groups")
    }
    
    func joinGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(GroupDataError.notAuthenticated))
            return
        }
        
        // TODO Test this
        accountabilityGroupExists(groupId: groupId) { [self] exists in
            if exists {
                // Add our userId as an active memeber memebers dictionary
                let newMember = ["members": [userId: true]]
                
                self.groupsReference.document(groupId).setData(newMember, merge: true, completion: { error in
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                    completion(.success(()))
                })
            }
        }
    }
    
    func createGroup(name: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(GroupDataError.notAuthenticated))
            return
        }
        
        let groupId = String(UUID().uuidString.prefix(13).replacingOccurrences(of: "-", with: ""))
        let group = AccountabilityGroup(id: groupId, name: name, members: [userId: true], groupId: groupId, adminId: userId)
        
        do {
            let _ = try self.groupsReference.document(groupId).setData(from: group)
            completion(.success(groupId))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func leaveGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(GroupDataError.notAuthenticated))
            return
        }
                
        groupsReference.document(groupId).getDocument(completion: { [weak self] documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let document = documentSnapshot else {
                    completion(.failure(UserDataError.fetching))
                    return
                }
                
                guard let group = try? document.data(as: AccountabilityGroup.self) else {
                    completion(.failure(GroupDataError.decoding))
                    return
                }
                
                // Remove our userId from memebers dictionary
                var members = group.members
                
                // Delete group all together if we are the only memeber
                if members.count == 1 {
                    self?.deleteGroup(groupId: groupId) { result in
                        completion(result)
                    }
                    return
                }
                    
                // Remove self from members list
                members.removeValue(forKey: userId)

                // If this user was the admin
                    // Assign admin status to someone else
                    // Remove self from group
                if userId == group.adminId {
                    guard let nextAdminId = members.first?.key else {
                        completion(.failure(GroupDataError.reassigningAdmin))
                        return
                    }
                    
                    self?.groupsReference.document(groupId).updateData([
                        "adminId": nextAdminId,
                        "members": members
                    ], completion: { error in
                        if let error = error {
                            completion(.failure(error))
                        }
                        
                        completion(.success(()))
                    })
                } else {
                    self?.groupsReference.document(groupId).updateData([
                        "members": members
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
    
    // MARK: - Helper Functions
    
    private func accountabilityGroupExists(groupId: String, completion: @escaping (Bool) -> Void) {
        let groupsIdReference = groupsReference.whereField("groupId", isEqualTo: groupId)
        groupsIdReference.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot,
               querySnapshot.documents.count > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func deleteGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        groupsReference.document(groupId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

enum GroupDataError: Error {
    case notAuthenticated
    case groupDoesNotExist
    case reassigningAdmin
    case decoding
    case encoding
}
