//
//  LeaderboardViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    
    private var groupGoals: [Goal]
    private var thisUserId: String
    private var memberNames: [String: String]
    var leaderboardProgressBarViewModels = [LeaderboardProgressBarViewModel]()
        
    init(groupGoals: [Goal], memberNames: [String: String], thisUserId: String) {
        self.groupGoals = groupGoals
        self.memberNames = memberNames
        self.thisUserId = thisUserId
        
        compileLeaderboardProgessBarViewModels()
    }
    
    private func compileLeaderboardProgessBarViewModels() {
        /// [UserId: Associated View Model]
        var progressBarViewModels = [String: LeaderboardProgressBarPresentationModel]()
        
        // Compile progress bar presentation models
        for goal in groupGoals {
            guard let userId = goal.userId else {
                continue
            }
            
            if var progressBarViewModel = progressBarViewModels[userId] {
                // Increment total goal values for exisiting presentation model
                progressBarViewModel.totalThisWeek += goal.timesThisWeek
                progressBarViewModel.totalPerWeek += goal.timesPerWeek
                progressBarViewModels[userId] = progressBarViewModel
            } else {
                // Create new presentation model
                let memberName: String? = userId == thisUserId ? "Me" : memberNames[userId]
                progressBarViewModels[userId] = LeaderboardProgressBarPresentationModel(
                    memberName: memberName ?? "No Name",
                    totalThisWeek: goal.timesThisWeek,
                    totalPerWeek: goal.timesPerWeek,
                    groupRank: -999,
                    userId: userId
                )
            }
        }
        
        // Create progress bar view models from progress bar presentation models
        let unsortedLeaderboardModels: [LeaderboardProgressBarViewModel] =
            progressBarViewModels.map({ leaderboardModelDictionary in
                let presentationModel = leaderboardModelDictionary.value
                return LeaderboardProgressBarViewModel(presentationModel: presentationModel)
            })
        
        // Sort progress bar view models
        let sortedLeaderboardModels = unsortedLeaderboardModels.sorted(by: { $0.totalProgress > $1.totalProgress })
        
        // Set leaderboard group ranking values for each progress bar
        var last: (rank: Int, progress: Double) = (0, 0.0)
        for (index, viewModel) in sortedLeaderboardModels.enumerated() {
            if index == 0 {
                viewModel.setGroupRank(1)
                last.rank = 1
                last.progress = viewModel.totalProgress
            } else if viewModel.totalProgress == last.progress {
                viewModel.setGroupRank(last.rank)
            } else {
                viewModel.setGroupRank(index + 1)
                last.rank = index + 1
                last.progress = viewModel.totalProgress
            }
        }
        
        leaderboardProgressBarViewModels = sortedLeaderboardModels
    }
}
