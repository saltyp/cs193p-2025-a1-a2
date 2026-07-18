//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/13/26.
//

import SwiftUI

struct ElapsedTime: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var format: SystemFormatStyle.DateOffset {
        .offset(to: startTime! - elapsedTime, allowedFields: [.minute, .second])
    }
    
    var body: some View {
        if let startTime {
            if let endTime {
                Text(endTime,format: format)
            } else {
                Text(TimeDataSource<Date>.currentDate,format: format)
            }
        } else {
             Image(systemName: "pause")
        }
    }
}

//#Preview {
//    ElapsedTime()
//}
