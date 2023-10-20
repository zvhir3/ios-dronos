//
//  MissionDrones.swift
//  DronosUTM
//
//  Created by zvhir on 29/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

struct MissionDrones: View {
    
    var missionId: String
    var schedules: [MissionModel.Schedule]
    
    var boxSize: CGFloat {
        (UIScreen.main.bounds.width - 15 * 2) / CGFloat(2)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 0) {
                    Text("EQUIPMENT’S DETAIL")
                        .font(.system(size: 14))
                        .kerning(4)
                        .foregroundColor(Color(red: 0.93, green: 0.96, blue: 0.97))
                        .padding(.top, 10)
                    Spacer()
                }
                .padding(.top, 10)
                
                ForEach(0..<schedules.count, id: \.self) { index in
                    let startDateString = dateFormatter.string(from: dateFormatter.date(from: schedules[index].startDate ?? "N/A") ?? Date())
                    MissionDroneCard(
                        index: index,
                        missionId: missionId,
                        date: startDateString,
                        drones: schedules[index].drones ?? []
                    )
                }
                
            }
        }
    }
    
    
    struct MissionDroneCard: View {
        
        var index: Int
        var missionId: String
        var date: String
        var drones: [MissionModel.Drone]
        
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
            ForEach(0..<drones.count, id: \.self) { index in
                DroneView(
                    modelBrand: drones[index].droneId?.catalogId?.brand ?? "N/A",
                    modelName: drones[index].droneId?.catalogId?.model ?? "N/A",
                    modelSerial: drones[index].droneId?.serialNumber ?? "N/A"
                )
            }
        }
    }
    
    
    struct DroneView: View {
        let modelBrand: String
        let modelName: String
        let modelSerial: String
        
        var boxSize: CGFloat {
            (UIScreen.main.bounds.width - 15 * 2) / CGFloat(2)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .center) {
                    Image("drone")
                        .resizable()
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: boxSize - 30, height: 110)
                }
                Text(modelBrand + " " + modelName)
                    .font(
                        Font.custom("Barlow", size: 11)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .padding(.leading, 12)
                Rectangle()
                    .foregroundColor(Color.gray)
                    .frame( height: 24)
                    .cornerRadius(5)
                    .overlay(
                        Text("Serial: " + modelSerial)
                            .font(Font.custom("Barlow", size: 11))
                            .foregroundColor(.white)
                    )
                    .padding(.horizontal, 12)
            }
            .frame(width: boxSize, height: boxSize)
            .background(Constants.DronosSecondaryColor)
            .cornerRadius(10)
        }
    }
    
    
    
    @ViewBuilder
    func renderBox(imageName: String, middleText: String, bottomText: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .center) {
                Image(imageName)
                    .resizable()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: boxSize - 30, height: 110)
            }
            Text(middleText)
                .font(
                    Font.custom("Barlow", size: 11)
                        .weight(.medium)
                )
                .foregroundColor(.white)
                .padding(.leading, 12)
            Rectangle()
                .foregroundColor(Color.gray)
                .frame( height: 24)
                .cornerRadius(5)
                .overlay(
                    Text(bottomText)
                        .font(Font.custom("Barlow", size: 11))
                        .foregroundColor(.white)
                )
                .padding(.horizontal, 12)
        }
        .frame(width: boxSize, height: boxSize)
        .background(Constants.DronosSecondaryColor)
        .cornerRadius(10)
    }
    
    
    
}
