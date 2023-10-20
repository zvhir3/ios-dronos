//
//  MissionSchedule.swift
//  DronosUTM
//
//  Created by zvhir on 29/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//import SwiftUI

import SwiftUI

struct MissionSchedules: View {
    
    var missionId: String
    var schedules: [MissionModel.Schedule]
    var boxSize: CGFloat {
        UIScreen.main.bounds.width - 10 * 2
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm a"
        return formatter
    }
    
    var body: some View {
        print("Mission ID: \(missionId)")
        return ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 0) {
                    Text("MISSION SCHEDULE")
                        .font(.system(size: 14))
                        .kerning(4)
                        .foregroundColor(Color(red: 0.93, green: 0.96, blue: 0.97))
                        .padding(.top, 10)
                    Spacer()
                }
                .padding(.top, 10)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: .infinity, height: 1)
                    .background(Color(red: 0.38, green: 0.43, blue: 0.47))
                ForEach(0..<schedules.count, id: \.self) { index in
                    let startDateString = dateFormatter.string(from: dateFormatter.date(from: schedules[index].startDate ?? "N/A") ?? Date())
                    let endDateString = dateFormatter.string(from: dateFormatter.date(from: schedules[index].endDate ?? "N/A") ?? Date())
                    
                    MissionScheduleCard(index: index, missionId: missionId, startDate: startDateString, endDate: endDateString)
                }
                
            }
        }
    }
}

struct MissionScheduleCard: View {
    
    var index: Int
    var missionId: String
    var startDate: String
    var endDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 4) {
                Text("Schedule \(index + 1)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                
                Image("dot")
                    .resizable() // Add this
                    .frame(width: 5, height: 5)
                
                Text(missionId)
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(startDate + " to " + endDate)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
        }
        .padding(.leading, 16)
        .padding(.trailing, 20)
        .padding(.vertical, 12)
        .frame(width: .infinity, alignment: .topLeading)
        .background(Color(red: 0.22, green: 0.25, blue: 0.3).opacity(0.8))
        .background(.white.opacity(0.05))
        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 11)
        .cornerRadius(5)
    }
}
