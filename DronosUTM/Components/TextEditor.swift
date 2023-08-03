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
        //            .padding()
        //            .foregroundColor(Color(UIColor.fromHex(0x00F0FF)))
        //            .font(.body)
        //            .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
        //            .cornerRadius(10)
        //            .frame(height: 49)
        //            .border(Color.clear, width: 0)
        
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
}

extension SecureField {
    func loginSecureFieldStyle() -> some View {
        self
        //            .padding()
        //            .foregroundColor(Color(UIColor.fromHex(0x00F0FF)))
        //            .font(.body)
        //            .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
        //            .cornerRadius(10)
        //            .frame(height: 49)
        //            .border(Color.clear, width: 0)
            .padding(.horizontal, 60)
            .foregroundColor(Color.white)
            .padding(.vertical, 5)
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
