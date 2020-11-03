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
    
    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            let height = geometry.size.height
            let circleDiameter = height
            let barHeight = height * 0.6
            let barWidth = width * 0.85
            let cornerRadius: CGFloat = height
            
            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: barWidth, height: barHeight)
                        .opacity(0.5)
                        .foregroundColor(.red)
                    
                    RoundedRectangle(cornerRadius: cornerRadius/2)
                        .frame(width: min(CGFloat(self.totalProgress) * barWidth, barWidth), height: barHeight)
                        .animation(.linear)
                }
                .offset(x: width * 0.15)
                
                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: circleDiameter, height: circleDiameter)
                    
                    Circle()
                        .frame(width: circleDiameter * 0.875, height: circleDiameter * 0.875, alignment: .center)
                        .opacity(1.0)
                        .foregroundColor(.white)
                    
                    Circle()
                        .frame(width: circleDiameter * 0.75, height: circleDiameter * 0.75, alignment: .center)
                    
                    Text(String(format: "%.0f%%", min(self.totalProgress, 1.0) * 100.0))
                        .font(.system(size: height > width ? width * 0.25: height * 0.25))
                        .bold()
                        .foregroundColor(.black)
                }
            }
        }
        .foregroundColor(Color.greenRedProgress(progress: totalProgress))
    }
}

#if DEBUG
struct PersonalGoalsProgressBar_Previews: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 1.0).allGoalsProgress)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.125, alignment: .center)
        }
    }
}
#endif

struct MockPersonalGoalsProgress {
    var allGoalsProgress: Double
}
