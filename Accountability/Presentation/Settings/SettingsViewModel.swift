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
    
    @Published var user: User!
        
    private let fetchUserUseCase = UseCaseProvider().fetchUserUseCase
    private let updateUserUseCase = UseCaseProvider().updateUserUseCase
    private let logOutUserUseCase = UseCaseProvider().logOutUserUseCase
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchUserUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userResponse):
                self.user = userResponse
                   
                // TODO: Probably going to want to delete this. Don't want users to be able to change things so easily
//                self.$user
//                    .dropFirst()
//                    .debounce(for: 1.0, scheduler: RunLoop.main)
//                    .sink { [weak self] user in
//                        self?.updateUser(user: user!)
//                }
//                .store(in: &self.cancellables)
                
            case .failure(let error):
                //fatalError(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    func logOutUser() {
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
