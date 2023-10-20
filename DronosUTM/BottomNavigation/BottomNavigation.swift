//
//  BottomNavigation.swift
//  DronosUTM
//
//  Created by zvhir on 25/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

struct BottomNavigation: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(red: 0.13, green: 0.15, blue: 0.2))
        UITabBar.appearance().unselectedItemTintColor = UIColor(.gray)
    }
    var body: some View {
        TabView {
            LaunchpadControllerWrapper()
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Image(systemName: "skew")
                    Text("Launchpad")
                }
//            MissionsPage()
//                .tabItem {
//                    Image(systemName: "map")
//                    Text("Missions")
//                }
            ProfilePage()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .tint(Color(.white))
    }
}
