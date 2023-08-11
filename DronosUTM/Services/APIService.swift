import Foundation

class APIService {
    
    // Login API
    static func login(_ data: LoginData, completion: @escaping (Bool) -> Void) {
        let urlString = Constants.baseURL + Constants.loginEndpoint
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": data.email, "password": data.password]
        let jsonData = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   (response.statusCode == 200 || response.statusCode == 201) {
                    // Successful login
                    print("Login successful!", data)
                    // let newToken = data.token
                    // UserDefaults.standard.set(newToken, forKey: "token")
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []),
                       let tokenFull = (responseData as? [String: Any])?["token"] as? String {
                        let prefix = "Bearer "
                        let token = String(tokenFull.suffix(tokenFull.count - prefix.count))
                        // Access the token from the response data and save it to UserDefaults
                        UserDefaults.standard.set(token, forKey: "token")
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    // Login failed
                    print("Login failed!")
                    completion(false)
                }
            }
        }.resume()
    }
    
    // Forgot Password API
    static func forgotPassword(email: String, completion: @escaping (Bool) -> Void) {
        let urlString = Constants.baseURL + Constants.forgotPasswordEndpoint
        let requestBody: [String: String] = ["email": email]
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error creating request body: \(error)")
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send OTP!", error)
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 201 {
                    print("OTP successfully sent!")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("Failed to send OTP!")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }.resume()
    }
    
    // Verify OTP API
    static func verifyOTP(otp: String, email: String, completion: @escaping (Bool) -> Void) {
        let urlString = Constants.baseURL + Constants.verifyOtpEndpoint
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData: [String: Any] = [
            "otp": String(otp),
            "email": email
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) else {
            print("Failed to serialize JSON data")
            completion(false)
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                    if let json = try? JSONSerialization.jsonObject(with: responseData, options: []),
                       let jsonDict = json as? [String: Any],
                       let  _ = jsonDict["message"] as? String {
                        
                        DispatchQueue.main.async {
                            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                                print("Verified")
                                completion(true)
                            } else {
                                print("Unverified")
                                completion(false)
                            }
                        }
                        
                    }
                    else {
                        print("sini errr")
                        completion(false)
                    }
                } else {
                    print("Failed")
                    completion(false)
                }
            }
        }.resume()
    }
    
    
    // Reset Password API
    static func resetPassword( email: String, password: String, completion: @escaping (Bool) -> Void) {
        let urlString = Constants.baseURL + Constants.resetPasswordEndpoint
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let _: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                print("Error: \(httpResponse.description)")
                if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    if let json = try? JSONSerialization.jsonObject(with: responseData, options: []),
                       let jsonDict = json as? [String: Any],
                       let  _ = jsonDict["message"] as? String {
                        
                        DispatchQueue.main.async {
                            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                                print("Reset successfully")
                                completion(true)
                            } else {
                                print("Failed to reset")
                                completion(false)
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    // Fetch Mission API
    
    struct Mission: Decodable {
        let missionId: String
        let name: String
        let schedules: [Schedule]
        let location: String
        let area: Area
        let drones: [Drones]
    }
    
    struct Area: Decodable {
        let coordinate: [Coordinate]
    }
    
    struct Coordinate: Decodable {
        let latitude: String
        let longitude: String
        
        var latitudeDouble: Double {
            return Double(latitude ?? "") ?? 0.0
        }
        
        var longitudeDouble: Double {
            return Double(longitude ?? "") ?? 0.0
        }
    }
    
    struct Schedule: Decodable {
        let startDate: String
        let endDate: String
        let startTime: Int
        let endTime: Int
    }
    
    struct Drones: Decodable {
        let model: String
        let name: String
    }
    
    static func fetchMissions(completion: @escaping ([Mission]) -> Void) {
        let urlString = Constants.baseURL + Constants.fetchMissionEndpoint
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print("Error fetching missions: \(error)")
                }
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                guard let records = jsonData["records"] as? [[String: Any]] else {
                    print("Error extracting 'records' from the JSON")
                    completion([])
                    return
                }
                
                let missions = try records.map { record -> Mission in
                    let missionId = record["missionId"] as? String ?? ""
                    let name = record["name"] as? String ?? ""
                    let location = record["location"] as? String ?? ""
                   
                    guard let areaDict = record["area"] as? [String: Any] else {
                        print("Error extracting 'area' from the record")
                        return Mission(missionId: missionId, name: name, schedules: [], location: location, area: Area(coordinate: []), drones: [])
                    }
                    
                    let areaData = try JSONSerialization.data(withJSONObject: areaDict, options: [])
                    var area = try decoder.decode(Area.self, from: areaData)
                    
                    
                    let schedulesDict = record["schedules"] as? [[String: Any]] ?? []
                    let schedules = try schedulesDict.map { scheduleDict -> Schedule in
                        let startDate = scheduleDict["startDate"] as? String ?? ""
                        let endDate = scheduleDict["endDate"] as? String ?? ""
                        let startTime = scheduleDict["startTime"] as? Int ?? 0
                        let endTime = scheduleDict["endTime"] as? Int ?? 0
                        return Schedule(startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime)
                    }
                    
                    let dronesDict = record["drones"] as? [[String: Any]] ?? []

                    let drones = dronesDict.compactMap { singleDroneDict -> Drones? in
                        if let droneIdDict = singleDroneDict["droneId"] as? [String: Any],
                           let catalogDict = droneIdDict["catalogId"] as? [String: Any] {
                            let droneModel = catalogDict["model"] as? String ?? ""
                            let droneName = catalogDict["name"] as? String ?? ""
                            return Drones(model: droneModel, name: droneName)
                        }
                        return nil
                    }
                    
                    
                    return Mission(missionId: missionId, name: name, schedules: schedules, location: location, area: area, drones: drones)
                }
                
                DispatchQueue.main.async {
                    completion(missions)
                }
            } catch {
                print("Error decoding mission data: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }

    
    func getData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func postData(url: URL, body: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case noData
}

//To use the service
//
//let apiService = APIService()
//
//let apiUrl = URL(string: "https://example.com/api/endpoint")!
//
//apiService.getData(url: apiUrl) { result in
//    switch result {
//    case .success(let data):
//        // Handle successful response
//        print("Received data:", data)
//    case .failure(let error):
//        // Handle error
//        print("Error:", error)
//    }
//}

