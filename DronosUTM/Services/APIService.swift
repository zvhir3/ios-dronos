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

