//
//  ViewMission.swift
//  DronosUTM
//
//  Created by zvhir on 27/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//
import SwiftUI

struct ViewMissionView: View {
    let missionID: String

    var body: some View {
        Text("Mission ID: \(missionID)")
            .navigationBarTitle("Mission Details", displayMode: .inline)
    }
}
