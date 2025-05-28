//
//  ViewController.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import UIKit
import SnapKit

protocol IToDoListController {
    var presenter: ToDoListInteractorInput? { get set }
    
    func updateNewTaskViewSubTitle(currentDate: String)
    func reloadTable()
    func updateFilterTaskView(countTasks: (allTask: Int, openTask: Int, closedTask: Int))
    func updateFilterTaskViewButton(state: FilterEnableType)
}

protocol IUpdateTaskDelegate: AnyObject {
    func reloadAndFetchList()
}

class ToDoListController: UIViewController, IToDoListController {
    
    var presenter: ToDoListInteractorInput?
    
    var newTaskView = NewTaskView()
    var filterTaskView = FilterTaskView()
    
    lazy var tableView: UITableView = {
        $0.backgroundColor = Colors.backGroundColor
        $0.dataSource = self
        $0.delegate = self
        $0.register(ToDoListCell.self, forCellReuseIdentifier: ToDoListCell.reuseId)
        $0.separatorStyle = .none
        
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupViews()
        setupConstraints()
        setupBindings()
        
        presenter?.fetchToDoList()
        presenter?.fetchCurentDate()
        presenter?.fetchTaskCount()
    }
    
    func setupViews() {
        
        view.backgroundColor = Colors.backGroundColor
        [newTaskView, filterTaskView, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        
        newTaskView.snp.makeConstraints { make in
            make.left.right.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        filterTaskView.snp.makeConstraints { make in
            make.top.equalTo(newTaskView.snp.bottom)
            make.left.right.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterTaskView.snp.bottom).offset(13)
            make.left.right.bottom.equalTo(view)
        }
    }
}

//MARK: - UITableViewDataSource

extension ToDoListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.toDolistCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListCell.reuseId, for: indexPath) as? ToDoListCell else { return UITableViewCell() }
        
        if let toDoTask = presenter?.getToDoTask(index: indexPath.row) {
            cell.update(toDoTask)
        }
        cell.onCheckBoxButtonTap = { [weak self] in
            self?.taskCheckBoxSelected(index: indexPath)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.presenter?.deleteTask(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskCellSelected(index: indexPath)
    }
    
}

//MARK: - Update View

extension ToDoListController {
    func updateNewTaskViewSubTitle(currentDate: String) {
        newTaskView.update(date: currentDate)
    }
}

extension ToDoListController {
    func updateFilterTaskView(countTasks: (allTask: Int, openTask: Int, closedTask: Int)) {
        filterTaskView.update(countTasks: countTasks)
    }
}

extension ToDoListController {
    func updateFilterTaskViewButton(state: FilterEnableType) {
        filterTaskView.updateColorButton(state: state)
    }
}

extension ToDoListController {
    func reloadTable() {
        presenter?.fetchTaskCount()
        tableView.reloadData()
    }
}

//MARK: - Pop-Up Add Task
extension ToDoListController {
    private func handleAddTaskTap() {
        
        let alert = UIAlertController(title: "New Task", message: "Enter task description", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Title"
        }
        alert.addTextField { textField in
            textField.placeholder = "Task description"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            
            let title = alert.textFields?[0].text
            let taskDescription = alert.textFields?[1].text
            if let title = title, !title.isEmpty,
               let taskDescription = taskDescription, !taskDescription.isEmpty {
                self?.presenter?.addNewTask(title: title, description: taskDescription)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            alert.textFields?.first?.becomeFirstResponder()
        }
    }
}

//MARK: - Delegate

extension ToDoListController: IUpdateTaskDelegate {
    func reloadAndFetchList() {
        presenter?.fetchToDoList()
        tableView.reloadData()
    }
}

//MARK: - Event Handlers

extension ToDoListController {
    func setupBindings() {
        
        newTaskView.onCheckBoxButtonTap = { [weak self] in
            self?.handleAddTaskTap()
        }
        filterTaskView.onAllTaskButtonTap = { [weak self] in
            self?.presenter?.filterTask(state: FilterEnableType.all)
            self?.presenter?.updateColorButton(state: FilterEnableType.all)
        }
        
        filterTaskView.onOpenTaskButtonTap = { [weak self] in
            self?.presenter?.filterTask(state: FilterEnableType.open)
            self?.presenter?.updateColorButton(state: FilterEnableType.open)
        }
        
        filterTaskView.onClosedTaskButtonTap = { [weak self] in
            self?.presenter?.filterTask(state: FilterEnableType.closed)
            self?.presenter?.updateColorButton(state: FilterEnableType.closed)
        }
    }
    
    func taskCheckBoxSelected(index: IndexPath) {
        presenter?.updateCompletion(index: index.row)
    }
    
    func taskCellSelected(index: IndexPath) {
        presenter?.taskCellSelected(index.row)
    }
}
