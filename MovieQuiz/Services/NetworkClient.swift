//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Anka on 15.03.2023.
//

import Foundation


/// URL загрузка данных
struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверка на ошибку
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возврат данных
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
