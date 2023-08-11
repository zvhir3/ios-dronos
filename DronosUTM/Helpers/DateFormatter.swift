//
//  DateFormatter.swift
//  DronosUTM
//
//  Created by Hidayatul Nadhirah on 09/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation

func formattedDate(from dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = inputFormatter.date(from: dateString) else {
        return "Invalid Date" // or some default value
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd MMM yyyy"
    return outputFormatter.string(from: date)
}
