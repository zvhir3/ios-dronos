//
//  Constants.swift
//  DronosUTM
//
//  Created by zvhir on 20/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation

enum Constants {
    static let MAPBOX_TOKEN = "pk.eyJ1IjoiaW50dWl0aXZlYmFkZ2VyIiwiYSI6ImNrOXZpeXZiNzBkN3Iza29saHhjOWo2OGwifQ.QOMbmOzi8OhYw6NYyDqBRQ"
    static let MAPBOX_STYLE = "mapbox://styles/intuitivebadger/clf659i6e003m01o9seb9u6l0"
    
    static let baseURL = "https://dev-api.dronos.ai"
    static let loginEndpoint = "/account/auth/login"
    static let logoutEndpoint = "/account/auth/logout"
    static let registerEndpoint = "/account/users/signup"
    static let deactivateAccEndpoint = "/account/users/"
    static let forgotPasswordEndpoint = "/account/auth/forgot-password"
    static let verifyOtpEndpoint = "/account/auth/verify-otp"
    static let getProfileEndpoint = "/account/users/profile"
    static let resetPasswordEndpoint = "/account/auth/reset-password"
    static let fetchMissionEndpoint = "/mission/missions"
}

