//
//  SettingsViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

protocol SettingsViewModelProtocol {
    
    func logOutUser()
}

class SettingsViewModel: ObservableObject {
    
    @Published var user: User?
        
    private let fetchUserUseCase = UseCaseProvider().fetchUserUseCase
    private let updateUserUseCase = UseCaseProvider().updateUserUseCase
    private let leaveGroupUseCase = UseCaseProvider().leaveGroupUseCase
    private let logOutUserUseCase = UseCaseProvider().logOutUserUseCase
    
    private var cancellables = Set<AnyCancellable>()

    var groupId: String? {
        user?.groupId
    }
    
    init(user: User) {
        self.user = user
    }

    func leaveGroupButtonTapped(completion: @escaping (Result<Void, Error>) -> Void) {
        leaveGroupUseCase.execute { result in
            completion(result)
        }
    }
    
    func logOutButtonTapped() {
        logOutUserUseCase.execute { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("Error logging out user: \(error.localizedDescription)")
            }
        }
    }

    private func updateUser(user: User) {
        updateUserUseCase.execute(request: user) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                switch error {
                case UserDataError.duplicateUsername:
                    // Getting called for wrong reasons
                    print("TODO: Handle this case")
                default:
                    print("Error updating user: \(error.localizedDescription)")
                }
            }
        }
    }
}
