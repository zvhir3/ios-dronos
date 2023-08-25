//
//  BottomNavigation.swift
//  DronosUTM
//
//  Created by zvhir on 25/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

struct MissionSheet: View {
    
    @Binding var isShowing: Bool
    var missionId: String
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Text("Are you want to go offline? If yes then you can go offline or also you can snooz availability or stay online if not.")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.bottom, 24)
                .padding(.bottom, 42)
                .transition(.move(edge: .bottom))
                .cornerRadius(16, corners: [.topLeft, .topRight])
            }
        }
        .frame(maxWidth: 500, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

struct RoundedSheetCorners: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedSheetCorners(radius: radius, corners: corners) )
    }
}
//
//
//import SwiftUI
//
//struct MissionSheet: View {
//    
//    @State var isShowingBottomSheet = false
//    
//    var body: some View {
//        ZStack{
//            
//            Button{
//                withAnimation{
//                    isShowingBottomSheet.toggle()
//                }
//            } label: {
//                Text("Open Bottom Sheet")
//            }
//            
//            BottomSheet(isShowing: $isShowingBottomSheet)
//        }
//    }
//}
//
//struct BottomSheet: View {
//    
//    @Binding var isShowing: Bool
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            if (isShowing) {
//                Color.black
//                    .opacity(0.3)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        isShowing.toggle()
//                    }
//                VStack(alignment: .leading) {
//                    HStack {
//                        Text("Go Online")
//                            .foregroundColor(.black.opacity(0.9))
//                            .font(.system(size: 20, weight: .bold))
//                        
//                        Spacer()
//                    }
//                    .padding(.top, 16)
//                    .padding(.bottom, 4)
//                    
//                    Text("Are you want to go offline? If yes then you can go offline or also you can snooz availability or stay online if not.")
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundColor(.black.opacity(0.7))
//                        .padding(.bottom, 24)
//                }
//                .padding(.bottom, 42)
//                .transition(.move(edge: .bottom))
//                .background(
//                    Color(uiColor: .white)
//                )
//                .cornerRadius(16, corners: [.topLeft, .topRight])
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//        .ignoresSafeArea()
//        .animation(.easeInOut, value: isShowing)
//    }
//}
//
//struct RoundedSheetCorners: Shape {
//    
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
//
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape( RoundedSheetCorners(radius: radius, corners: corners) )
//    }
//}
