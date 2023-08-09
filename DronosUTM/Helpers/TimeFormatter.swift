//
//  TimeFormatter.swift
//  DronosUTM
//
//  Created by Hidayatul Nadhirah on 08/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation

func formatTime(_ time: Int) -> String {
    let hour = time / 100
    let minute = time % 100

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"

    let dateComponents = DateComponents(hour: hour, minute: minute)
    let date = Calendar.current.date(from: dateComponents)!

    return dateFormatter.string(from: date)
}

func formatDateTime(_ time: Int) -> Date {
    let hour = time / 100
    let minute = time % 100
    return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
}
