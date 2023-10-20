//
//  ApiManager.swift
//  DronosUTM
//
//  Created by zvhir on 22/09/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class ApiManager {
    
    /* ++++++++++++++++++++++++++++++ API SETUP ++++++++++++++++++++++++++++++++++ */
    static let shared = ApiManager()
    
    private func fetchTokenFromRealmDB() -> String? {
        // Implement your logic to fetch the token from RealmDB here
        let realm = try! Realm()
        if let authSession = realm.objects(AuthSession.self).first {
            return authSession.token
        }
        return nil
    }
    
    func fetchMissions(completion: @escaping (Result<MissionModel, Error>) -> Void) {
        guard let token = fetchTokenFromRealmDB() else {
            let error = NSError(domain: "Dronos UTM Mobile", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token is not available"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.baseURL + Constants.fetchMissionEndpoint
        let workspaceId = "651e496089047c917da1a167"
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)",
            "workspaceid": workspaceId
        ]
      
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: MissionModel.self) { response in
                print("\n\n\n")
                print(asciiArt)
                print("\n")
                print("URL: " + url + "\nToken: " + token + "\nWorkspace ID: " + workspaceId + "\n")
                switch response.result {
                case .success(let missionData):
                    print("Missions fetched successfully")
                    completion(.success(missionData))
                    print("\n\n")
                case .failure(let error):
                    print("Missions fetching failed")
                    completion(.failure(error))
                    print("\n\n")
                }
            }
    }



}


func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
    
    let parameters: [String: Any] = [
        "email": email,
        "password": password
    ]
    
    AF.request(Constants.baseURL + Constants.loginEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .validate()
        .response { response in
            switch response.result {
            case .success(let responseData):
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                let formattedDate = dateFormatter.string(from: currentDate)
                
                print("Login success.")
                print("Login timestamp: \(formattedDate)")
                
                if let headers = response.response?.allHeaderFields as? [String: String],
                   let setCookieHeader = headers["Set-Cookie"] {
                    
                    // Split the "Set-Cookie" header into individual cookie attributes
                    let cookieAttributes = setCookieHeader.split(separator: ";").map { String($0.trimmingCharacters(in: .whitespaces)) }
                    
                    // Extract the "refreshToken" attribute
                    if let refreshTokenAttribute = cookieAttributes.first(where: { $0.hasPrefix("refreshToken=") }) {
                        // Extract the value of the "refreshToken" attribute
                        var refreshTokenValue = refreshTokenAttribute.replacingOccurrences(of: "refreshToken=", with: "")
                        
                        // Replace "%20" with a space
                        refreshTokenValue = refreshTokenValue.replacingOccurrences(of: "%20", with: " ")
                        
                        // Find the "Expires" attribute in the cookie attributes
                        if let expiresAttribute = cookieAttributes.first(where: { $0.hasPrefix("Expires=") }) {
                            // Extract the value of the "Expires" attribute
                            let expiresValue = expiresAttribute.replacingOccurrences(of: "Expires=", with: "").trimmingCharacters(in: .whitespaces)
                            
                            // Declare a variable to store the token
                            var token = "N/A"
                            
                            // Unwrap the responseData safely
                            if let responseData = responseData {
                                do {
                                    let json = try JSON(data: responseData)
                                    if let tokenData = json["token"].string {
                                        token = tokenData
                                    }
                                } catch {
                                    print("Failed to parse token from reponse: \(error.localizedDescription)")
                                }
                            }
                            
                            // Update the Realm database
                            let realm = try! Realm()
                            
                            // Use Realm's query capabilities to find or create an AuthSession object
                            var authSession: AuthSession?
                            try! realm.write {
                                authSession = realm.objects(AuthSession.self).first
                                if authSession == nil {
                                    authSession = AuthSession()
                                    realm.add(authSession!)
                                }
                                
                                print("\n\n\n")
                                print(asciiArt)
                                print("\n\n\n")
                                
                                let separatorLine = "------------------------------------------------------"
                                
                                print("Token:\n\(token)")
                                print("\n\n\n")
                                print("Refresh Token:\n\(refreshTokenValue)")
                                print("\n\n\n")
                                print("\(separatorLine)")
                                print("| Token Initiated at : \(formattedDate) |")
                                print("| Token Expired at   : \(expiresValue) |")
                                print("\(separatorLine)")
                                
                                authSession!.token = token // Save the token here
                                authSession!.tokenInitiatedAt = formattedDate
                                authSession!.tokenExpiredAt = expiresValue
                                authSession!.refreshToken = refreshTokenValue
                            }
                            
                            // Print the Realm file URL
                            if let realmFileURL = realm.configuration.fileURL {
                                print("\n\n\n")
                                print("Realm Database Location: \(realmFileURL)")
                                print("\n\n\n")
                            }
                            
                            completion(true)
                        }
                    }
                }
            case .failure(let error):
                print("Login failed. Error: \(error.localizedDescription)")
                completion(false)
            }
        }
}
