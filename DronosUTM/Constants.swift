//
//  Constants.swift
//  DronosUTM
//
//  Created by zvhir on 20/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import SwiftUI

enum Constants {
    
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
    
    
    static let MAPBOX_TOKEN = "pk.eyJ1IjoiaW50dWl0aXZlYmFkZ2VyIiwiYSI6ImNrOXZpeXZiNzBkN3Iza29saHhjOWo2OGwifQ.QOMbmOzi8OhYw6NYyDqBRQ"
    static let MAPBOX_STYLE = "mapbox://styles/intuitivebadger/clf659i6e003m01o9seb9u6l0"
    
    static let baseURL = "https://dev-api.dronos.ai"
    static let loginEndpoint = "/account/auth/login"
    static let logoutEndpoint = "/account/auth/logout"
    static let refreshTokenEndpoint = "/account/auth/refreshtoken"
    static let registerEndpoint = "/account/users/signup"
    static let deactivateAccEndpoint = "/account/users/"
    static let forgotPasswordEndpoint = "/account/auth/forgot-password"
    static let verifyOtpEndpoint = "/account/auth/verify-otp"
    static let getProfileEndpoint = "/account/users/profile"
    static let resetPasswordEndpoint = "/account/auth/reset-password"
    static let fetchMissionEndpoint = "/mission/missions"
    static let fetchMissionDetailsEndpoint = "/mission/missions/"
    
    
    static let DronosMainColor = Color(red: 0.13, green: 0.15, blue: 0.2)
    static let DronosSecondaryColor = Color(red: 0.21, green: 0.24, blue: 0.27)
    static let DronosAccentColor =  Color(red: 0.19, green: 0.88, blue: 0.93)
    
    static let keychainService = "com.yourapp.keychain"
    static let keychainEmailKey = "email"
    static let keychainPasswordKey = "password"
    
    //}
    //
    //fileprivate enum Constants {
    //    static let radius: CGFloat = 16
    //    static let indicatorHeight: CGFloat = 6
    //    static let indicatorWidth: CGFloat = 60
    //    static let snapRatio: CGFloat = 0.25
    //    static let minHeightRatio: CGFloat = 0.3
}
    
