//
//  ToDoListLoader.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

protocol IToDoListLoader {
    func fetchToDoList(completion: @escaping (Result<[TaskModel], Error>) -> Void)
}

enum NetworkError: Error {
    case decode
}

class TaskLoader: IToDoListLoader {
                
    let session = URLSession.init(configuration: .default)
    
    func fetchToDoList(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        let userUrl = URL(string: "https://dummyjson.com/todos")
        
        var request = URLRequest(url: userUrl!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200..<300:
                    break
                default:
                    print("\(response.statusCode)")
                }
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder.init()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let toDoListData = try decoder.decode(ToDolist.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(toDoListData.todos))
                }
                
            }catch {
                completion(Result.failure(NetworkError.decode))
                print(error)
            }
        }
        
        task.resume()
    }
}
