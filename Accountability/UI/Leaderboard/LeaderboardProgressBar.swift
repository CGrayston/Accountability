//
//  LeaderboardProgressBar.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct LeaderboardProgressBar: View {
            
    var viewModel: LeaderboardProgressBarViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Color.barBackground
                    .border(Color.gray, width: 0.25)
                
                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(viewModel.totalProgress))
                    .border(Color.gray, width: 0.25)
                    .foregroundColor(Color.greenRedProgress(progress: viewModel.totalProgress))
                
                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        if viewModel.groupRank == 1 {
                            Image(systemName: "star.square.fill")
                        } else if viewModel.groupRank <= 50 {
                            Image(systemName: "\(viewModel.groupRank).square.fill")
                        }
                        
                        Text(viewModel.memberName)
                            .truncationMode(.tail)
                        
                        Spacer()
                        Text(viewModel.progressPercentage)
                    }
                    .lineLimit(1)
                    .font(.title)
                    
                    Text("Finished \(viewModel.totalThisWeek) out of \(viewModel.totalPerWeek) goals this week")
                        .font(.body)
                }
                .padding(.horizontal)
                .foregroundColor(.black)
            }
        }
    }
}

#if DEBUG
struct LeaderboardProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                let presentationModel = LeaderboardProgressBarPresentationModel(
                    memberName: "Chris Super Duper Long Name",
                    totalThisWeek: 15,
                    totalPerWeek: 27,
                    groupRank: 1,
                    userId: "1111"
                )
                let viewModel = LeaderboardProgressBarViewModel(presentationModel: presentationModel)
                LeaderboardProgressBar(viewModel: viewModel)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15)

                
                let presentationModel2 = LeaderboardProgressBarPresentationModel(
                    memberName: "Peter",
                    totalThisWeek: 3,
                    totalPerWeek: 14,
                    groupRank: 2,
                    userId: "1111"
                )
                let viewModel2 = LeaderboardProgressBarViewModel(presentationModel: presentationModel2)
                LeaderboardProgressBar(viewModel: viewModel2)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
            }
        }
    }
}
#endif
