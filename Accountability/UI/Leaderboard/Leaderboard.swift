//
//  Leaderboard.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct Leaderboard: View {
    
    @ObservedObject var viewModel: LeaderboardViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let barHeight = geometry.size.height / 7
            
            ZStack(alignment: .top) {
                Color.background
                    .ignoresSafeArea()
                
                LazyVStack(spacing: 0) {
                    let leaderboardViewModels = viewModel.leaderboardProgressBarViewModels
                    ForEach(leaderboardViewModels.indices) { i in
                        LeaderboardProgressBar(viewModel: leaderboardViewModels[i])
                    }
                    .frame(height: barHeight)
                }
                .font(.title3)
            }
        }
        .navigationBarTitle("Leaderboard", displayMode: .automatic)
    }
}

#if DEBUG
struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        
        let goals: [Goal] = [
            Goal(title: "Title", timesThisWeek: 1,  timesPerWeek: 4, weekStart: Date(), weekEnd: Date(), userId: "1111"),
            Goal(title: "Title", timesThisWeek: 2,  timesPerWeek: 4, weekStart: Date(), weekEnd: Date(), userId: "1111"),
            Goal(title: "Title", timesThisWeek: 3,  timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "2222"),
            Goal(title: "Title", timesThisWeek: 4,  timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "2222"),
            Goal(title: "Title", timesThisWeek: 0,  timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "3333"),
            Goal(title: "Title", timesThisWeek: 4,  timesPerWeek: 15, weekStart: Date(), weekEnd: Date(), userId: "3333"),
        ]
        
        let viewModel = LeaderboardViewModel(groupGoals: goals, memberNames: ["1111": "Boston", "2222": "Chris", "3333": "Peter"], thisUserId: "1111")
        Group {
            Leaderboard(viewModel: viewModel)
            Leaderboard(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
#endif


private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()

extension Int {
    var ordinal: String? {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}
