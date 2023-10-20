//
//  ProfileModel.swift
//  DronosUTM
//
//  Created by zvhir on 16/10/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation

struct ProfileModel: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let socialLinks: [String] // You can replace String with the actual type of social links
    let verified: Bool
    let userCertificate: [String] // You can replace String with the actual type of userCertificate
    let pilotInformation: [String] // You can replace String with the actual type of pilotInformation
    let accountLinks: [String] // You can replace String with the actual type of accountLinks
    let createdAt: String
    let updatedAt: String
    let member: [Member]

    struct Member: Codable {
        let id: String
        let user: String
        let role: Role
        let inviteAccepted: Bool
        let organisation: String
        let workspace: Workspace
        let createdAt: String
        let updatedAt: String
        let inviteTime: String
        let recordType: String

        struct Role: Codable {
            let id: String
            let name: String
            let permissions: [String]
        }

        struct Workspace: Codable {
            let id: String
            let name: String
        }
    }
}
