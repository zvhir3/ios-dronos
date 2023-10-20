//
//  MissionOperators.swift
//  DronosUTM
//
//  Created by zvhir on 29/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

struct MissionOperators: View {
    var missionId: String
    var schedules: [MissionModel.Schedule]
    
    var boxSize: CGFloat {
        UIScreen.main.bounds.width - 10 * 2
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 0) {
                    Text("OPERATOR DETAILS")
                        .font(.system(size: 14))
                        .kerning(4)
                        .foregroundColor(Color(red: 0.93, green: 0.96, blue: 0.97))
                        .padding(.top, 10)
                    Spacer()
                }
                ForEach(0..<schedules.count, id: \.self) { index in
                    MissionOperatorCard(
                        index: index,
                        missionId: missionId,
                        date: schedules[index].startDate ?? "N/A",
                        operators: schedules[index].operatorAssign ?? ["N/A"]
                    )
                }
            }
        }
    }
}

struct MissionOperatorCard: View {
    
    var index: Int
    var missionId: String
    var date: String
    var operators: [String]

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("Schedule \(index + 1)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Text(date)
                .font(Font.custom("Barlow", size: 14))
                .foregroundColor(.white.opacity(0.6))
                .padding(.leading, 10)
        }
        .padding(.top, 5)
        ForEach(0..<operators.count, id: \.self) { index in
            OperatorView(name: operators[index], email: operators.first ?? "N/A")
        }

    }
}

struct OperatorView: View {
    let name: String
    let email: String

    var boxSize: CGFloat {
        UIScreen.main.bounds.width - 10 * 2
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            VStack(alignment: .center) {
                Image("btn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(50)
                    .padding(16)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(Font.custom("Barlow", size: 12).weight(.medium))
                    .foregroundColor(.white)
                Text(email)
                    .font(Font.custom("Barlow", size: 10).weight(.medium))
                    .foregroundColor(.white)
            }
            Spacer()
            Rectangle()
                .foregroundColor(Color.gray)
                .frame(width: 80, height: 24)
                .cornerRadius(5)
                .overlay(
                    Text("Pilot")
                        .font(Font.custom("Barlow", size: 14))
                        .foregroundColor(.white)
                )
                .padding(.horizontal, 12)
        }
        .frame(width: boxSize, height: 70)
        .background(Constants.DronosSecondaryColor)
        .cornerRadius(10)
    }
}
