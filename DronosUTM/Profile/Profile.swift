//
//  Profile.swift
//  DronosUTM
//
//  Created by zvhir on 27/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//
import SwiftUI

struct ProfilePage: View {
    var body: some View {
        VStack {
            Image("profile")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 400)
            VStack(alignment: .leading, spacing: 12) {
                LabelText(text: "John Doe", textColor: .black, font: .title)
                LabelText(text: "Mobile Apps Developer", textColor: .gray, font: .body)
                Divider()
                HStack {
                    Image(systemName: "envelope")
                    LabelText(text: "me@zvhir.com", textColor: .black, font: .body)
                }
                HStack {
                    Image(systemName: "phone")
                    LabelText(text: "+60165585600", textColor: .black, font: .body)
                }
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}
