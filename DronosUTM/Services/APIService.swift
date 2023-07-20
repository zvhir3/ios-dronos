import Foundation

class APIService {
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
    
    // login EP
    static func login(_ data: LoginData, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://dev-api.dronos.ai/account/auth/login")!
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
                    //                    let newToken = data.token
                    //                    UserDefaults.standard.set(newToken, forKey: "token")
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
                    //                    completion(false)
                } else {
                    // Login failed
                    print("Login failed!")
                    completion(false)
                }
            }
        }.resume()
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

