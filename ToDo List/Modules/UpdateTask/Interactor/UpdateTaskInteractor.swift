//
//  UpdateTaskInteractor.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

protocol IUpdateTaskInteractor {
    var presenter: UpdateTaskPresenterOutput? { get set }
    
    func saveTask(task: TaskModel)
    
    func updateTask(id: Int, title: String, description: String)
}

class UpdateTaskInteractor: IUpdateTaskInteractor {
    
    var presenter: UpdateTaskPresenterOutput?
    
    var taskStorage: TaskStorage?
    
    func saveTask(task: TaskModel) {
        presenter?.savedTask(task: task)
    }
    
    func updateTask(id: Int, title: String, description: String) {
        
        let taskMO = taskStorage?.fetchTasks() ?? []
        
        let matchingTasks = taskMO.filter { $0.id == id }
        if let taskToUpdate = matchingTasks.first {
            
            self.taskStorage?.updateTaskTitleAndDescription(task: taskToUpdate, title: title, description: description)
            
        } else {
            print("Error: Task not found in CoreData")
        }
    }
}
