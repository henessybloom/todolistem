//
//  ToDoListInteractor.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

protocol IToDoListInteractor {
    var toDoListLoader: IToDoListLoader? { get set }
    var presenter: ToDolistInteractorOutput? { get set }
    var taskStorage: ITaskStorage? { get set }
    
    func fetchToDoList()
    func fetchCurentDate()
    func addNewTask(title: String, description: String)
    func fetchTaskCount()
    
    //Filter task
    func filterOpenTask(state: FilterEnableType)
    func updateColorButton(button: FilterEnableType)
    
    //Datasource
    func toDolistCount() -> Int
    func getToDoTask(index: Int) -> TaskModel
    
    //Core Data
    func updateCompletion(index: Int, filter: String)
    func deleteTask(index: Int, filter: String)
    
    //Event Handler
    func taskCellSelected(_ index: Int)
}

class ToDoListInteractor: IToDoListInteractor {
    
    var taskStorage: ITaskStorage?
    
    var toDoListLoader: IToDoListLoader?
    
    var presenter: ToDolistInteractorOutput?
    
    var toDoLists: [TaskModel] = []
    
    func fetchToDoList() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in

            if self?.taskStorage?.fetchTasks() == [] {
                self?.toDoListLoader?.fetchToDoList(completion: { [weak self] result in
                    switch result {
                    case .success(let toDolistData):
                        self?.toDoLists = toDolistData
                        self?.taskStorage?.saveTasks(toDolistData)
                        self?.toDoLists = self?.taskStorage?.fetchTaskModels() ?? []
                        
                        DispatchQueue.main.async {
                            self?.presenter?.fetchedToDoList(toDoList: toDolistData)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            } else {
                self?.toDoLists = self?.taskStorage?.fetchTaskModels() ?? []
                
                DispatchQueue.main.async {
                    self?.presenter?.fetchedToDoList(toDoList: self?.toDoLists ?? [])
                }
            }
        }
    }
    
    func fetchCurentDate() {
        let date = Date()
        presenter?.fetchedCurentData(currentDate: date)
    }
    
    func updateCompletion(index: Int, filter: String) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let nameTask = toDoLists[index].id
            let taskMO = taskStorage?.fetchTasks() ?? []
            
            let matchingTasks = taskMO.filter { $0.id == nameTask }
            if let taskToUpdate = matchingTasks.first {
                self.taskStorage?.updateTaskCompletion(task: taskToUpdate)
            } else {
                print("Error: Task not found in CoreData")
            }
            
            toDoLists = taskStorage?.fetchTaskModels() ?? []
            //TODO: - add state pattern
            switch filter {
            case "Open":
                toDoLists = toDoLists.filter { $0.completed == false }
            case "Closed":
                toDoLists = toDoLists.filter { $0.completed == true }
            default:
                toDoLists = taskStorage?.fetchTaskModels() ?? []
            }
            
            DispatchQueue.main.async {
                self.presenter?.fetchedToDoList(toDoList: self.toDoLists)
            }
        }
    }
    
    func deleteTask(index: Int, filter: String) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let nameTask = toDoLists[index].id
            let taskMO = taskStorage?.fetchTasks() ?? []
            
            let matchingTasks = taskMO.filter { $0.id == nameTask }
            if let taskToUpdate = matchingTasks.first {
                self.taskStorage?.deleteTask(taskToUpdate)
            } else {
                print("Error: Task not found in CoreData")
            }
            
            toDoLists = taskStorage?.fetchTaskModels() ?? []
            
            switch filter {
            case "Open":
                toDoLists = toDoLists.filter { $0.completed == false }
            case "Closed":
                toDoLists = toDoLists.filter { $0.completed == true }
            default:
                toDoLists = taskStorage?.fetchTaskModels() ?? []
            }
            
            DispatchQueue.main.async {
                self.presenter?.fetchedToDoList(toDoList: self.toDoLists)
            }
        }
    }
    
    func addNewTask(title: String, description: String) {
        DispatchQueue.global(qos: .background).async {
            let date = Date()
            
            let formattedTime = AppDateFormatter.shared.formartTimeForTaskCreationTime(date: date)
            
            let formattedDate = AppDateFormatter.shared.formartDateForTaskCreationDate(date: date)
            
            if let lastId = self.toDoLists.max(by: { $0.id < $1.id }) {
                let newLastId = lastId.id + 1
                self.taskStorage?.saveTask(title: title, subTitle: description, startTime: formattedTime, endTime: "13:00PM", date: formattedDate, isComplete: false, id: newLastId)
            }
            
            self.toDoLists = self.taskStorage?.fetchTaskModels() ?? []
            DispatchQueue.main.async {
                self.presenter?.fetchedToDoList(toDoList: self.toDoLists)
            }
        }
    }
    
    func fetchTaskCount() {
        presenter?.fetchedTaskCount()
    }
    
    func filterOpenTask(state: FilterEnableType) {
        toDoLists = taskStorage?.fetchTaskModels() ?? []
        
        switch state {
        case .open:
            toDoLists = toDoLists.filter { $0.completed == false }
        case .closed:
            toDoLists = toDoLists.filter { $0.completed == true }
        default:
            toDoLists = taskStorage?.fetchTaskModels() ?? []
        }
        
        presenter?.fetchedToDoList(toDoList: toDoLists)
        
    }
    
    func updateColorButton(button: FilterEnableType) {
        presenter?.updatedColorButton(button: button)
    }
}

//MARK: - Datasource
extension ToDoListInteractor {
    func toDolistCount() -> Int {
        return toDoLists.count
    }
    
    func getToDoTask(index: Int) -> TaskModel {
        return toDoLists[index]
    }
}

//MARK: - Event Handler

extension ToDoListInteractor {
    func taskCellSelected(_ index: Int) {
        let task = toDoLists[index]
        presenter?.fetchedTask(task: task)
    }
}
