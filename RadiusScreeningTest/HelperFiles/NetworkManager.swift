//
//  NetworkManager.swift
//  RadiusScreeningTest
//
//  Created by Manu on 28/06/23.
//

import Foundation
enum NetworkError: Error {
    case invalidUrl
    case invalidData
}

fileprivate enum URLMethod: String{
    case GET
}

typealias facilityDataCompletionClosure = ((Facilities?, Error?) -> Void)

struct NetworkManager{
    private func executeRequest<T: Codable>(request: URLRequest, completion: ((T?, Error?) -> Void)?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion?(decodedData, nil)
                }
            }catch let error{
                print("Getting error in decoding the data", error.localizedDescription)
                completion?(nil, NetworkError.invalidData)
            }
        }
        dataTask.resume()
    }
    
    
    private func createRequest(for url: String, method: URLMethod) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    func getFacilityData(completion: facilityDataCompletionClosure?){
        guard let request = createRequest(for: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db", method: .GET) else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
}
