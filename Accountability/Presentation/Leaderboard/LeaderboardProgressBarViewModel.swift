//
//  LeaderboardProgressBarViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class LeaderboardProgressBarViewModel: ObservableObject {

    private var presentationModel: LeaderboardProgressBarPresentationModel
       
    var memberName: String {
        presentationModel.memberName
    }
    
    var totalProgress: Double {
        Double(presentationModel.totalThisWeek)/Double(presentationModel.totalPerWeek)
    }
    
    var progressPercentage: String {
        String(format: "%.0f%%", min(totalProgress, 1.0) * 100.0)
    }
    
    var totalThisWeek: Int {
        presentationModel.totalThisWeek
    }
    
    var totalPerWeek: Int {
        presentationModel.totalPerWeek
    }
    
    var groupRank: Int {
        presentationModel.groupRank
    }
    
    func setGroupRank(_ newValue: Int) {
        self.presentationModel.groupRank = newValue
    }
    
    var userId: String {
        presentationModel.userId
    }
    
    init(presentationModel: LeaderboardProgressBarPresentationModel) {
        self.presentationModel = presentationModel
    }
}

struct LeaderboardProgressBarPresentationModel {
    var memberName: String
    var totalThisWeek: Int
    var totalPerWeek: Int
    var groupRank: Int
    var userId: String
}
