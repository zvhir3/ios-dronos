//
//  Splashscreen.swift
//  DronosUTM
//
//  Created by zvhir on 12/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

//struct Splashscreen: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

struct Splashscreen: View {
    @State private var logoIsVisible = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            if logoIsVisible {
                LogoView()
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 1.5))
            }
        }
        .onAppear {
            withAnimation {
                logoIsVisible = true
            }
        }
    }
}


struct LogoView: View {
    @State private var offsetY: CGFloat = 400
    
    var body: some View {
        Image("aerodyne")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .offset(y: offsetY)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    offsetY = 0
                }
            }
    }
}
