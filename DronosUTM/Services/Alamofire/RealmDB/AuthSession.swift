//
//  AuthSession.swift
//  DronosUTM
//
//  Created by zvhir on 03/10/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation
import RealmSwift

class AuthSession: Object {
    @objc dynamic var id = "authSession" // Constant primary key
    @objc dynamic var token: String = ""
    @objc dynamic var tokenInitiatedAt: String = ""
    @objc dynamic var tokenExpiredAt: String = ""
    @objc dynamic var refreshToken: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
