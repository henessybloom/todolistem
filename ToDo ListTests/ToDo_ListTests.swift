//
//  ToDo_ListTests.swift
//  ToDo ListTests
//
//  Created by Alina Kazantseva on 28.05.2025.
//

import XCTest
@testable import ToDo_List

final class ToDo_ListTests: XCTestCase {
    
    class ToDoListControllerSpy: IToDoListController {
        var presenter: (ToDo_List.ToDoListInteractorInput)?
        
        var updateNewTaskViewSubtitleCalled = false
        var reloadTableCalledCalled =  false
        var updateFilterTaskViewCalledCalled = false
        var updateFilterTaskViewButtonCalled = false
        
        func updateNewTaskViewSubTitle(currentDate: String) {
            updateNewTaskViewSubtitleCalled = true
        }
        
        func reloadTable() {
            reloadTableCalledCalled = true
        }
        
        func updateFilterTaskView(countTasks: (allTask: Int, openTask: Int, closedTask: Int)) {
            updateNewTaskViewSubtitleCalled = true
        }
        
        func updateFilterTaskViewButton(button: String) {
            updateFilterTaskViewButtonCalled = true
        }
        
    }
    
    class ToDoListPresenterSpy: ToDoListInteractorInput, ToDolistInteractorOutput {
        
        var view: (ToDo_List.IToDoListController)?
        
        var interactor: (ToDo_List.IToDoListInteractor)?
        
        var fetchToDoListCalled = false
        var fetchCurrentDateCalled = false
        var addNewTaskCalled = false
        var fetchTaskCountCalled = false
        var filterTaskCalled = false
        var updateColorButtonCalled = false
        var toDoListCountCalled = false
        var getToDoTaskCalled = false
        var updateCompletionCalled = false
        var deleteTaskCalled = false
        var taskCellSelectedCalled = false
        
        var fetchedToDoListCalled = false
        var fetchedCurrentDateCalled = false
        var fetchedTaskCountCalled = false
        var updatedColorButtonCalled = false
        var fetchedTaskCalled = false
        
        func fetchToDoList() {
            fetchToDoListCalled = true
        }
        
        func addNewTask(title: String, description: String) {
            addNewTaskCalled = true
            interactor?.addNewTask(title: title, description: description)
        }
        
        func fetchCurentDate() {
            fetchCurrentDateCalled = true
        }
        
        
        func toDolistCount() -> Int {
            toDoListCountCalled = true
            return 0
        }
        
        func fetchTaskCount() {
            fetchTaskCountCalled = true
        }
        
        func filterTask(button: String) {
            filterTaskCalled = true
        }
        
        func updateColorButton(state: String) {
            updateColorButtonCalled = true
        }
        
        func getToDoTask(index: Int) -> ToDo_List.TaskModel {
            getToDoTaskCalled = true
            return ToDo_List.TaskModel.mockObject()
        }
        
        func updateCompletion(index: Int) {
            updateCompletionCalled = true
        }
        
        func deleteTask(index: Int) {
            deleteTaskCalled = true
        }
        
        func taskCellSelected(_ index: Int) {
            taskCellSelectedCalled = true
        }
        
        func fetchedCurrentData(currentDate: Date) {
            fetchedCurrentDateCalled = true
            
        }
        
        func fetchedToDoList(toDoList: [ToDo_List.TaskModel]) {
            fetchedToDoListCalled = true
        }
        
        func fetchedTaskCount() {
            fetchedTaskCountCalled = true
        }
        
        func updatedColorButton(button: String) {
            updatedColorButtonCalled = true
        }
        
        func fetchedTask(task: ToDo_List.TaskModel) {
            fetchedTaskCalled = true
        }
        
        func fetchedCurentData(currentDate: Date) {
            fetchedCurrentDateCalled = true
        }
        
    }
    
    class ToDolistInteractorSpy: IToDoListInteractor {
        var taskStorage: (any ToDo_List.ITaskStorage)?
        
        var toDoListLoader: (any ToDo_List.IToDoListLoader)?
        var presenter: (any ToDo_List.ToDolistInteractorOutput)?
        
        var fetchToDoListCalled = false
        var fetchCurrentDateCalled = false
        var addNewTaskCalled = false
        var fetchTaskCountCalled = false
        var filterOpenTaskCalled = false
        var updateColorButtonCalled = false
        var toDoListCountCalled = false
        var getToDoTaskCalled = false
        var updateCompletionCalled = false
        var deleteTaskCalled = false
        var taskCellSelectedCalled = false

        func fetchToDoList() {
            fetchToDoListCalled = true
        }
        
        func fetchCurentDate() {
            fetchCurrentDateCalled = true
        }
        
        func addNewTask(title: String, description: String) {
            addNewTaskCalled = true
        }
        
        func fetchTaskCount() {
            fetchTaskCountCalled = true
            
        }
        
        func filterOpenTask(button: String) {
            filterOpenTaskCalled = true
            
        }
        
        func updateColorButton(button: String) {
            updateColorButtonCalled = true
        }
        
        func toDolistCount() -> Int {
            toDoListCountCalled = true
            return 0
        }
        
        func getToDoTask(index: Int) -> ToDo_List.TaskModel {
            getToDoTaskCalled = true
            return ToDo_List.TaskModel.mockObject()
        }
        
        func updateCompletion(index: Int, filter: String) {
            updateCompletionCalled = true
        }
        
        func deleteTask(index: Int, filter: String) {
            deleteTaskCalled = true
        }
        
        func taskCellSelected(_ index: Int) {
            taskCellSelectedCalled = true
        }
    }
//MARK: - Test Presenter
    func testPresenterCallsViewDidLoad() {
        //given
        let toDolistController = ToDoListController()
        let toDolistPresenter = ToDoListPresenterSpy()
        
        toDolistController.presenter = toDolistPresenter
        toDolistPresenter.view = toDolistController
        
        //when
        let _ = toDolistController.view
        
        //then
        XCTAssertTrue(toDolistPresenter.fetchToDoListCalled)
        XCTAssertTrue(toDolistPresenter.fetchCurrentDateCalled)
        XCTAssertTrue(toDolistPresenter.fetchTaskCountCalled)
        
    }
    
    func testPresenterCallsReloadtable() {
        //given
        let toDolistController = ToDoListController()
        let toDolistPresenter = ToDoListPresenterSpy()
        
        toDolistController.presenter = toDolistPresenter
        toDolistPresenter.view = toDolistController
        
        //when
        let _ = toDolistController.reloadTable()
        
        //then
        XCTAssertTrue(toDolistPresenter.fetchTaskCountCalled)
    }
    
    func testPresenterCallsAddNewTask() {
        // given
        let toDolistController = ToDoListController()
        let toDolistPresenter = ToDoListPresenterSpy()
        let toDolistInteractor = ToDolistInteractorSpy()
        
        toDolistController.presenter = toDolistPresenter
        toDolistPresenter.view = toDolistController
        toDolistPresenter.interactor = toDolistInteractor
        
        // when
        let _ = toDolistPresenter.addNewTask(title: "Test Title", description: "Test Description")
        
        // then
        XCTAssertTrue(toDolistInteractor.addNewTaskCalled)
    }
    
    func testPresenterCallsFilterTask() {
        // given
        let toDoListController = ToDoListController()
        let toDolistPresenter = ToDoListPresenterSpy()
        
        // when
        toDolistPresenter.filterTask(button: "All")
        
        // then
        XCTAssertTrue(toDolistPresenter.filterTaskCalled)
    }
    
    func testPresenterCallsUpdateColorButton() {
        // given
        let toDolistPresenter = ToDoListPresenterSpy()
        
        // when
        toDolistPresenter.updateColorButton(state: "All")
        
        // then
        XCTAssertTrue(toDolistPresenter.updateColorButtonCalled)
    }
    
    func testPresenterCallsToDolistCount() {
        // given
        let toDolistPresenter = ToDoListPresenterSpy()
        
        // when
        let _ = toDolistPresenter.toDolistCount()
        
        // then
        XCTAssertTrue(toDolistPresenter.toDoListCountCalled)
    }
    
    func testPresenterCallsDeleteTask() {
        // given
        let toDolistPresenter = ToDoListPresenterSpy()
        
        // when
        toDolistPresenter.deleteTask(index: 0)
        
        // then
        XCTAssertTrue(toDolistPresenter.deleteTaskCalled)
    }
    
    func testPresenterCallsUpdateCompletion() {
        // given
        let toDolistPresenter = ToDoListPresenterSpy()
        
        // when
        toDolistPresenter.updateCompletion(index: 0)
        
        // then
        XCTAssertTrue(toDolistPresenter.updateCompletionCalled)
    }
//MARK: - Test Interactor
    
    func testFetchToDolistCalls() {
        //given
        let toDoListPresenter = ToDoListPresenter()
        let toDolistInteractor = ToDolistInteractorSpy()
        
        toDoListPresenter.interactor = toDolistInteractor
        toDolistInteractor.presenter = toDoListPresenter
        
        //when
        toDoListPresenter.fetchToDoList()
        toDoListPresenter.fetchCurentDate()
        //then
        XCTAssertTrue(toDolistInteractor.fetchToDoListCalled)
    }
    
    func testFetchCurrentDateCalls() {
        //given
        let toDoListPresenter = ToDoListPresenter()
        let toDolistInteractor = ToDolistInteractorSpy()
        
        toDoListPresenter.interactor = toDolistInteractor
        toDolistInteractor.presenter = toDoListPresenter
        
        //when
        toDoListPresenter.fetchCurentDate()
        toDoListPresenter.fetchTaskCount()
        
        //then
        XCTAssertTrue(toDolistInteractor.fetchCurrentDateCalled)
    }
    
    func testFetchTaskCountCalls() {
        //given
        let toDolistPresenter = ToDoListPresenter()
        let toDolistInteractor = ToDolistInteractorSpy()
        
        toDolistPresenter.interactor = toDolistInteractor
        toDolistInteractor.presenter = toDolistPresenter
        //when
        toDolistPresenter.fetchTaskCount()
        //then
        XCTAssertTrue(toDolistInteractor.fetchTaskCountCalled)
    }
    
    func testAddNewTaskCalls() {
        //given
        let toDolistPresenter = ToDoListPresenter()
        let toDolistInteractor = ToDolistInteractorSpy()
        
        toDolistPresenter.interactor = toDolistInteractor
        toDolistInteractor.presenter = toDolistPresenter
        //when
        toDolistPresenter.addNewTask(title: "New Task", description: "New description")
        //then
        XCTAssertTrue(toDolistInteractor.addNewTaskCalled)
    }
    
    func testFetchTaskCountInteractorCalls() {
        //given
        let toDoListPresenter = ToDoListPresenter()
        let toDolistInteractor = ToDolistInteractorSpy()
        
        toDoListPresenter.interactor = toDolistInteractor
        toDolistInteractor.presenter = toDoListPresenter
        //when
        toDoListPresenter.fetchTaskCount()
        //then
        XCTAssertTrue(toDolistInteractor.fetchTaskCountCalled)
    }
//MARK: - Test API request
    func testFetchToDoListThroughtAPI() {
        //given
        let taskLoaderStub = TaskLoaderStub(emulateError: false)
        let taskLoaderTask = TaskLoader()
        //when
        let expectation = expectation(description: "Loader expectation")
        
        taskLoaderTask.fetchToDoList { result in
            
            switch result {
            case .success(let task):
                XCTAssertEqual(task.count, 30)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failer")
            }
        }
        //then
        waitForExpectations(timeout: 5)
    }
//MARK: - Test Entity
    
    func testTaskModel() {
        //when
        let task = TaskModel(id: 1, todo: "Gym", description: "I am going to gym", date: "Friday, 20", startTime: "11:00 AM", endTime: "12:00 PM", completed: false, userId: 1)
        //then
        XCTAssertEqual(task.id, 1)
        XCTAssertEqual(task.todo, "Gym")
        XCTAssertEqual(task.description, "I am going to gym")
        XCTAssertEqual(task.date, "Friday, 20")
    }

}
