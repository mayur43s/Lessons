//
//  NetworkManager.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    static let baseUrl = "https://iphonephotographyschool.com/test-api"
    private let lessonUrl = baseUrl + "/lessons"

    func getLessons(completion: @escaping (Result<[Lesson], CustomError>) -> Void) {
        guard let url = URL(string: lessonUrl) else {
            completion(.failure(.notFound))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error = error {
                completion(.failure(.unexpected(code: (error as NSError).code)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let object = try decoder.decode(LessonsModel.self, from: data)
                completion(.success(object.lessons))
            } catch {
                completion(.failure(.unexpected(code: (error as NSError).code)))
            }
        }
        
        task.resume()
    }
}
