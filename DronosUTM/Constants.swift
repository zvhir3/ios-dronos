//
//  Constants.swift
//  DronosUTM
//
//  Created by zvhir on 20/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation

enum Constants {
    static let baseURL = "https://dev-api.dronos.ai"
    static let loginEndpoint = "/account/auth/login"
    static let forgotPasswordEndpoint = "/account/auth/forgot-password"
    static let verifyOtpEndpoint = "/account/auth/verify-otp"
    static let resetPasswordEndpoint = "/account/auth/reset-password"
    static let fetchMissionEndpoint = "/mission/missions"
}

