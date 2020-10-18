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
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                
                Rectangle().frame(width: min(CGFloat(self.totalProgress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .animation(.linear)
            }
            .foregroundColor(Color.greenRedProgress(progress: totalProgress))
            .cornerRadius(45.0)
        }
    }
}

#if DEBUG
struct PersonalGoalsProgressBar_Previews: PreviewProvider {
    
    static var previews: some View {
        PersonalGoalsProgressBar(totalProgress: MockPersonalGoalsProgress(allGoalsProgress: 0.89).allGoalsProgress)
            .frame(width: 375, height: 40, alignment: .center)
    }
}
#endif

struct MockPersonalGoalsProgress {
    var allGoalsProgress: Double
}
