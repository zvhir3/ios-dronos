//
//  TextEditor.swift
//  DronosUTM
//
//  Created by zvhir on 27/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

extension TextEditor {
    func textEditorStyle() -> some View {
        self
            .padding()
            .foregroundColor(Color(UIColor.fromHex(0x00F0FF)))
            .font(.body)
            .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
            .cornerRadius(10)
            .frame(height: 49)
            .border(Color.clear, width: 0)
    }
}

extension SecureField {
    func loginSecureFieldStyle() -> some View {
        self
            .padding()
            .foregroundColor(Color(UIColor.fromHex(0x00F0FF)))
            .font(.body)
            .background(Color(UIColor.fromHex(0x8EF9F9, opacity: 0.2)))
            .cornerRadius(10)
            .frame(height: 49)
            .border(Color.clear, width: 0)
    }
}
