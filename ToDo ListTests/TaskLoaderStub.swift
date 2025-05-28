//
//  TaskLoaderStub.swift
//  ToDo ListTests
//
//  Created by Alina Kazantseva on 28.05.2025.
//

import Foundation
@testable import ToDo_List

final class TaskLoaderStub: IToDoListLoader {
    
    enum StubError: Error {
        case testError
    }
    
    var emulateError: Bool
    
    init(emulateError: Bool) {
        self.emulateError = emulateError
    }
    
    func fetchToDoList(completion: @escaping (Result<[ToDo_List.TaskModel], any Error>) -> Void) {
        if emulateError {
            completion(.failure(StubError.testError))
        } else {
            let tasks = [
                TaskModel(id: 1, todo: "Gym", description: "I am going to gym", date: "Friday", startTime: "11:00 AM", endTime: "11:00 PM", completed: false, userId: 1),
                TaskModel(id: 1, todo: "Gym1", description: "I am going to gym", date: "Friday", startTime: "11:00 AM", endTime: "11:00 PM", completed: false, userId: 1),
                TaskModel(id: 2, todo: "Gym2", description: "I am going to gym", date: "Friday", startTime: "11:00 AM", endTime: "11:00 PM", completed: false, userId: 3),
                
            ]
            completion(.success(tasks))
        }
    }
}
