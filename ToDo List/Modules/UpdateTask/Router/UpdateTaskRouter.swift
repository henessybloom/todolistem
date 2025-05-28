//
//  UpdateTaskRouter.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

class UpdateTaskRouter {
    
    static func createModule(ref: UpdateTaskViewController) {
        let updateTaskPresenter = UpdateTaskPresenter()
        let updateTaskInteractor = UpdateTaskInteractor()
        let taskStorage = TaskStorage()
        
        ref.presenter = updateTaskPresenter
        updateTaskPresenter.interactor = updateTaskInteractor
        updateTaskInteractor.taskStorage = taskStorage
        updateTaskPresenter.interactor?.presenter = updateTaskPresenter
    }
}
