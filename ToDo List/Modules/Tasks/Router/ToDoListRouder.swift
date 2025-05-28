//
//  ToDoListRouder.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

protocol IToDoListRouter {
    static func createModule(ref: ToDoListController)
    func navigateToTaskScreen(task: TaskModel) -> UpdateTaskViewController
}

class ToDoListRouder: IToDoListRouter {
    
    static func createModule(ref: ToDoListController) {
        let toDoListPresenter = ToDoListPresenter()
        let toDoListInteractor = ToDoListInteractor()
        let toDoListLoader = TaskLoader()
        let taskStorage = TaskStorage()
        let toDoListRouter = ToDoListRouder()
        
        ref.presenter = toDoListPresenter
        toDoListPresenter.interactor = toDoListInteractor
        toDoListInteractor.toDoListLoader = toDoListLoader
        toDoListInteractor.taskStorage = taskStorage
        toDoListPresenter.interactor?.presenter = toDoListPresenter
        toDoListPresenter.view = ref
        toDoListPresenter.router = toDoListRouter
        toDoListPresenter.nextView = ref
        toDoListRouter.viewController = ref
        
    }
    
    weak var viewController: ToDoListController?
    
    func navigateToTaskScreen(task: TaskModel) -> UpdateTaskViewController {
        let vc = UpdateTaskViewController()
        
        vc.delegate = viewController
        
        UpdateTaskRouter.createModule(ref: vc)
        vc.update(task)
        return vc
    }
}
