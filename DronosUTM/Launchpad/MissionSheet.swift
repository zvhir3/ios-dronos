//
//  BottomNavigation.swift
//  DronosUTM
//
//  Created by zvhir on 25/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI
struct MissionSheet: View {
    
    var missionId: String
    var schedules: [MissionModel.Schedule]
    @State var showSheet: Bool? = nil
    @State private var selectedTab: Int = 0
    

    
    let tabs: [Tab] = [
        .init(icon: Image(systemName: "music.note")),
        .init(icon: Image(systemName: "film.fill")),
        .init(icon: Image(systemName: "book.fill")),
        .init(icon: Image(systemName: "book.fill"))
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Constants.DronosMainColor
            VStack(spacing: 10) {
                ZStack(alignment: .bottom) {
                    Image("mountain")
                        .resizable()
                        .scaledToFit()
                    LinearGradient(gradient: Gradient(colors: [.clear,  Color(red: 0.13, green: 0.15, blue: 0.2).opacity(1)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 100) // Adjust the height of the fading effect
                    HStack() {
                        VStack(alignment: .leading) {
                            Text("Gas leak Detection")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .kerning(0.72)
                                .foregroundColor(Color(red: 0.93, green: 0.96, blue: 0.97))
                            Text("\(missionId)")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .kerning(4)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer() // Add spacing between columns
                        
                        Text("Not Started")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    
                }
                NavigationView {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            // Tabs
                            Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            
                            // Views
                            TabView(selection: $selectedTab,
                                    content: {
                                MissionSchedules(missionId: missionId, schedules: schedules)
                                    .tag(0)
                                MissionOperators(missionId: missionId, schedules: schedules)
                                    .tag(1)
                                MissionDrones(missionId: missionId, schedules: schedules)
                                    .tag(2)
                                MissionInformatics()
                                    .tag(3)
                            })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                        .background(Constants.DronosMainColor)
                    }
                }
                .padding(10)
            }
        }
    }
}


struct Tab {
    var icon: Image?
}

struct Tabs: View {
    var fixed = true
    var tabs: [Tab]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    var body: some View {
        VStack (alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(0 ..< tabs.count, id: \.self) { row in
                    Button(action: {
                        withAnimation {
                            selectedTab = row
                        }
                    }, label: {
                        VStack(spacing: 0) {
                            HStack {
                                AnyView(tabs[row].icon)
                                    .foregroundColor(.white)
                            }
                            .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 35)
                        }
                        .frame(height: 35)
                        .background(selectedTab == row ? Constants.DronosAccentColor : Color.clear)
                    })
                    
                    .cornerRadius(5)
                    .buttonStyle(DefaultButtonStyle())
                }
            }
            .background(Constants.DronosSecondaryColor)
            .cornerRadius(5)
        }
        .onChange(of: selectedTab) { target in
            withAnimation {
                // Scroll to selected tab
            }
        }
        .onAppear(perform: {
            UIScrollView.appearance().backgroundColor = UIColor(Constants.DronosMainColor)
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}

