//
//  PersonalGoalsProgressBar.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/14/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct PersonalGoalsProgressBar: View {
    
    var totalProgress: Double
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            let height = geometry.size.height
            let circleDiameter = height
            let barHeight = height * 0.6
            let barWidth = width// * 0.85
            let cornerRadius: CGFloat = height
            
            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: barWidth, height: barHeight)
                        .opacity(0.5)
                        .foregroundColor(.barBackground)
                    
                    // TODO : Refactor this 
                    let progressBarWidth = totalProgress < 0.5 ?  CGFloat(self.totalProgress) * barWidth + circleDiameter/2 : min(CGFloat(self.totalProgress) * barWidth, barWidth)
                    RoundedRectangle(cornerRadius: cornerRadius/2)
                        .frame(width: progressBarWidth, height: barHeight)
                        .animation(.easeInOut)
                }
                
                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: circleDiameter, height: circleDiameter)
                    
                    Circle()
                        .frame(width: circleDiameter * 0.875, height: circleDiameter * 0.875, alignment: .center)
                        .opacity(1.0)
                        .foregroundColor(.background)
                    
                    Circle()
                        .frame(width: circleDiameter * 0.75, height: circleDiameter * 0.75, alignment: .center)
                    
                    Text(String(format: "%.0f%%", min(self.totalProgress, 1.0) * 100.0))
                        .font(.system(size: height > width ? width * 0.25: height * 0.25))
                        .bold()
                        .foregroundColor(.black)
                }
                .offset(x: CGFloat(totalProgress) * (width -  circleDiameter))
                .animation(.easeInOut)
            }
        }
        .foregroundColor(Color.greenRedProgress(progress: totalProgress))
    }
}

#if DEBUG
struct PersonalGoalsProgressBar_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.0).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.09).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.2).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.3).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.5).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.7).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 1.0).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                }
            }
            
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.0).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.09).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.2).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.3).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.5).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.7).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                    PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 1.0).allGoalsProgress)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
#endif

struct MockPersonalGoalsProgress {
    var allGoalsProgress: Double
}
