//
//  Label.swift
//  DronosUTM
//
//  Created by zvhir on 12/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//
//

import UIKit
import SwiftUI

extension UILabel {
    static func makeLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Barlow-Regular", size: 14)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.fromHex(0xffffff)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeConnectedDroneLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.fromHex(0xffffff)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

struct LabelText: View {
    var text: String
    var textColor: Color
    var font: Font
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(textColor)
    }
}
