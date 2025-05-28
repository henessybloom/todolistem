//
//  TaskStorage.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import CoreData

protocol ITaskStorage {
    func saveTasks(_ tasks: [TaskModel])
    func saveTask(title: String, subTitle: String, startTime: String, endTime: String, date: String, isComplete: Bool, id: Int)
    func fetchTasks() -> [TaskMO]
    func fetchTaskModels() -> [TaskModel]
    func deleteTask(_ task: TaskMO)
    func updateTaskCompletion(task: TaskMO)
    func updateTaskTitleAndDescription(task: TaskMO, title: String, description: String)
    
}

final class TaskStorage: ITaskStorage {
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo_List")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveTasks(_ tasks: [TaskModel]) {
        
        for item in tasks {
            saveTask(title: item.todo, subTitle: item.todo, startTime: "11:00AM", endTime: "13:00PM", date: item.date ?? "Friday, 20", isComplete: item.completed, id: item.id)
        }
    }
    
    func saveTask(title: String, subTitle: String, startTime: String, endTime: String, date: String, isComplete: Bool, id: Int) {
        let task = TaskMO(context: context)
        task.title = title
        task.subTitle = subTitle
        task.startTime = startTime
        task.endTime = endTime
        task.isComplete = isComplete
        task.date = date
        task.id = Int64(id)
        
        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
    
    func fetchTasks() -> [TaskMO] {
        let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    //[TaskMO] -> [TaskModel]
    func fetchTaskModels() -> [TaskModel] {
        let moTasks = fetchTasks()
        var taskModels: [TaskModel] = []
        for moTask in moTasks {
            let taskModel = TaskModel.init(id: Int(moTask.id) , todo: moTask.title ?? " ", description: moTask.subTitle ?? " ", date: moTask.date ?? "Friday, 20", startTime: moTask.startTime, endTime: moTask.endTime, completed: moTask.isComplete, userId: 1)
            taskModels.append(taskModel)
        }
        
        return taskModels
    }
    
    func deleteTask(_ task: TaskMO) {
        context.delete(task)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
        }
    }
    
    func updateTaskCompletion(task: TaskMO) {
        task.isComplete = !task.isComplete
        
        do {
            try context.save()
        } catch {
            print("Failed to update task: \(error.localizedDescription)")
        }
    }
    
    func updateTaskTitleAndDescription(task: TaskMO, title: String, description: String) {
        task.title = title
        task.subTitle = description
        
        do {
            try context.save()
        } catch {
            print("Failed to update task: \(error.localizedDescription)")
        }
    }
}
