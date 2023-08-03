//
//  TextEditor.swift
//  DronosUTM
//
//  Created by zvhir on 27/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

extension TextField {
    func textEditorStyle() -> some View {
        
        self
            .padding(.horizontal, 60)
            .padding(.vertical, 5)
            .foregroundColor(Color.white)
            .frame(width: .infinity, height: 48, alignment: .leading)
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 1, x: 1, y: 1)
            .overlay(
                HStack{
                    Image("emailIcon") // SF Symbol for a magnifying glass
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // Position the icon
                    Spacer()
                }
            )
    }
    
    func textEditorStyleActive() -> some View {
        self
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .frame(width: 342, height: 48, alignment: .leading)
            .background(.white.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 11)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0, green: 0.94, blue: 1), lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 0.5)
            )
    }
}

extension SecureField {
    
    func secureFieldStyleActive() -> some View {
        self
            .padding(.horizontal, 20)
            .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
            .padding(.vertical, 5)
            .frame(width: 342, height: 48, alignment: .leading)
            .background(.white.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 11)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0, green: 0.94, blue: 1), lineWidth: 1)
            )
            .overlay(
                HStack{
                    Image("pass-active") // SF Symbol for a magnifying glass
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // Position the icon
                    Spacer()
                    Image("visibility_off") // SF Symbol for a magnifying glass
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // Position the icon
                }
            )
    }
    func secureFieldStyle() -> some View {
        self
            .padding(.horizontal, 60)
            .foregroundColor(Color.white)
            .padding(.vertical, 5)
            .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
            .frame(width: .infinity, height: 48, alignment: .leading)
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 1, x: 1, y: 1)
            .overlay(
                HStack{
                    Image("passwordIcon") // SF Symbol for a magnifying glass
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // Position the icon
                    Spacer()
                    Image("visibility_off") // SF Symbol for a magnifying glass
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // Position the icon
                }
            )
    }
    
    
}
