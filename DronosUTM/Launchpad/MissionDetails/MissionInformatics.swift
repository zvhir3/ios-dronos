//
//  MissionInformatics.swift
//  DronosUTM
//
//  Created by zvhir on 29/08/2023.
//  Copyright © 2023 DJI. All rights reserved.

import SwiftUI

struct MissionInformatics: View {
    var boxSize: CGFloat {
        (UIScreen.main.bounds.width - 25 * 2) / CGFloat(4)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 0) {
                    Text("RISK INFORMATICS")
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
                HStack(alignment: .top, spacing: 0) {
                    Text("Weather Informatics")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Today")
                        .font(Font.custom("Barlow", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 5)
                HStack(spacing: 10) {
                    renderBox(imageName: "pin", topText: "SUNRISE", middleText: "7:26", bottomText: "Sunset at 19:27")
                    renderBox(imageName: "pin", topText: "RAINFALL", middleText: "10mm", bottomText: "Gloomy ahead")
                    renderBox(imageName: "pin", topText: "FEELS LIKE", middleText: "28c", bottomText: "Warm feeling")
                    renderBox(imageName: "pin", topText: "WIND", middleText: "-", bottomText: "-")
                }
                HStack(spacing: 10) {
                    renderBox(imageName: "pin", topText: "GUSTS", middleText: "6km/h", bottomText: "Moderate")
                    renderBox(imageName: "pin", topText: "HUMIDITY", middleText: "10%", bottomText: "Dew point")
                    renderBox(imageName: "pin", topText: "VISIBILITY", middleText: "23KM", bottomText: "Clear view")
                    renderBox(imageName: "pin", topText: "KP INDEX", middleText: "2.6nT", bottomText: "Queit")
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: .infinity, height: 1)
                    .background(Color(red: 0.38, green: 0.43, blue: 0.47))
                    .padding(.top, 10)
                HStack(alignment: .top, spacing: 0) {
                    Text("Airspace Informatics")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Today")
                        .font(Font.custom("Barlow", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 5)
                renderAirspaceBox()
                renderAirspaceBox()
                renderAirspaceBox()
            }
        }
    }
    
    @ViewBuilder
    func renderBox(imageName: String, topText: String, middleText: String, bottomText: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .top, spacing: 2) {
                Image(systemName: imageName)
                    .foregroundColor(Color(red: 0.53, green: 0.6, blue: 0.65))
                    .font(.system(size: 8))
                Text(topText)
                    .font(
                        Font.custom("Barlow", size: 8)
                            .weight(.semibold)
                    )
                    .kerning(0.4)
                    .foregroundColor(Color(red: 0.53, green: 0.6, blue: 0.65))
            }
            Text(middleText)
                .font(
                    Font.custom("Barlow", size: 24)
                        .weight(.medium)
                )
                .foregroundColor(.white)
            Text(bottomText)
                .font(
                    Font.custom("Barlow", size: 8)
                        .weight(.medium)
                )
                .foregroundColor(.white)
        }
        .frame(width: boxSize, height: boxSize)
        .background(Constants.DronosSecondaryColor)
        .cornerRadius(10)
    }
    
    @ViewBuilder
    func renderAirspaceBox() -> some View {
        ZStack {
            Rectangle()
                .frame(height: 100)
                .foregroundColor(Constants.DronosSecondaryColor)
                .cornerRadius(8)
            HStack {
                Rectangle()
                    .frame(width: 3, height: 100)
                    .foregroundColor(Color.yellow)
                    .cornerRadius(8)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Airspace Informatics")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Rectangle()
                        .foregroundColor(Color.gray)
                        .frame(width: 80, height: 24)
                        .cornerRadius(8)
                        .overlay(
                            Text("Ground Risk")
                                .font(Font.custom("Barlow", size: 14))
                                .foregroundColor(.white)
                        )
                }
                HStack {
                    Text("Preapproval required")
                        .font(Font.custom("Barlow", size: 12))
                        .kerning(0.4)
                        .foregroundColor(Color(red: 0.69, green: 0.75, blue: 0.77))
                    Spacer()
                    Text("2000m2")
                        .font(Font.custom("Barlow", size: 12))
                        .kerning(0.4)
                        .foregroundColor(Color(red: 0.69, green: 0.75, blue: 0.77))
                }
                
            }
            .padding(.horizontal)
        }
        .padding(.top, 10)
    }
    
    
}
