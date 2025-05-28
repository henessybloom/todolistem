//
//  ToDoListPresenter.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation
import CoreData

protocol ToDoListInteractorInput {
    var interactor: IToDoListInteractor? { get set }
    
    func fetchToDoList()
    func fetchCurentDate()
    func addNewTask(title: String, description: String)
    func fetchTaskCount()
    
    //Filter Task
    func filterTask(state: FilterEnableType)
    func updateColorButton(state: FilterEnableType)
    
    //Datasource
    func toDolistCount() -> Int
    func getToDoTask(index: Int) -> TaskModel
    
    //Core data
    func updateCompletion(index: Int)
    func deleteTask(index: Int)
    
    //Event Handler
    func taskCellSelected(_ index: Int)
}

protocol ToDolistInteractorOutput {
    var view: IToDoListController? { get set }
    
    func fetchedCurentData(currentDate: Date)
    func fetchedToDoList(toDoList: [TaskModel])
    func fetchedTaskCount()
    func updatedColorButton(button: FilterEnableType)
    func fetchedTask(task: TaskModel)
}

//MARK: - Input
class ToDoListPresenter: ToDoListInteractorInput {
    
    var interactor: IToDoListInteractor?
    var view: IToDoListController?
    var router: IToDoListRouter?
    var nextView: ToDoListController?
    
    var toDolists: [TaskModel] = [] {
        didSet {
            self.view?.reloadTable()
        }
    }
    
    var filter = "All"
    
    func fetchToDoList() {
        interactor?.fetchToDoList()
    }
    
    func fetchCurentDate() {
        interactor?.fetchCurentDate()
    }
    
    func updateCompletion(index: Int) {
        interactor?.updateCompletion(index: index, filter: filter)
    }
    
    func deleteTask(index: Int) {
        interactor?.deleteTask(index: index, filter: filter)
    }
    
    func addNewTask(title: String, description: String) {
        self.interactor?.addNewTask(title: title, description: description)
    }
    
    func fetchTaskCount() {
        interactor?.fetchTaskCount()
    }
    
    func filterTask(state: FilterEnableType) {
        filter = state.rawValue
        interactor?.filterOpenTask(state: state)
    }
    
    func updateColorButton(state: FilterEnableType) {
        interactor?.updateColorButton(button: state)
    }
}

//MARK: - Output
extension ToDoListPresenter: ToDolistInteractorOutput {
    func fetchedCurentData(currentDate: Date) {
        let formattedDate = AppDateFormatter.shared.formartDateForNewTask(date: currentDate)
        view?.updateNewTaskViewSubTitle(currentDate: formattedDate)
    }
    
    func fetchedToDoList(toDoList: [TaskModel]) {
        toDolists = toDoList
        
    }
    
    func fetchedTaskCount() {
        let countTasks: (allTask: Int, openTask: Int, closedTask: Int)
        let allTasks = toDolists.count
        var openTasks = 0
        var closedTasks = 0
        
        for item in toDolists {
            if item.completed {
                closedTasks += 1
            } else {
                openTasks += 1
            }
        }
        countTasks = (allTask: allTasks, openTask: openTasks, closedTask: closedTasks)
        
        view?.updateFilterTaskView(countTasks: countTasks)
    }
    
    func updatedColorButton(button: FilterEnableType) {
        view?.updateFilterTaskViewButton(state: button)
    }
    
    func fetchedTask(task: TaskModel) {
        let vc = router?.navigateToTaskScreen(task: task)
        
        vc?.modalPresentationStyle = .pageSheet
        if let sheet = vc?.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        nextView?.present(vc!, animated: true, completion: nil)
    }
}

//MARK: - Datasource

extension ToDoListPresenter {
    func toDolistCount() -> Int {
        return interactor?.toDolistCount() ?? 0
    }
    
    func getToDoTask(index: Int) -> TaskModel {
        return interactor!.getToDoTask(index: index)
    }
}

//MARK: - Event Handler

extension ToDoListPresenter {
    func  taskCellSelected(_ index: Int) {
        interactor?.taskCellSelected(index)
    }
}
