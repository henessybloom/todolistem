//
//  UpdateTaskPresenter.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

protocol UpdateTaskPresenterInput {
    
    var interactor: UpdateTaskInteractor? { get set }
    
    func saveTask(task: TaskModel)
    func updateTask(title: String, description: String)
}

protocol UpdateTaskPresenterOutput {
    func savedTask(task: TaskModel)
}

class UpdateTaskPresenter: UpdateTaskPresenterInput {
    
    var interactor: UpdateTaskInteractor?
    
    var toDolists: [TaskModel] = []
    
    func saveTask(task: TaskModel) {
        interactor?.saveTask(task: task)
    }
    
    func updateTask(title: String, description: String) {
        interactor?.updateTask(id: toDolists[0].id, title: title, description: description)
    }
}

extension UpdateTaskPresenter: UpdateTaskPresenterOutput {
    
    func savedTask(task: TaskModel) {
        toDolists.append(task)
    }
    
}
