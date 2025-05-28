//
//  AppDataFormate.swift
//  ToDo List
//
//  Created by Alina Kazantseva on 25.05.2025.
//

import Foundation

class AppDateFormatter {
    
    static let shared = AppDateFormatter()
    
    private init() {}
    
    let newTaskFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d, MMMM"
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }()
    
    let taskCreationTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }()
    
    let taskCreationDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d"
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }()
    
    func formartDateForNewTask(date: Date) -> String {
        let formattedDate = newTaskFormatter.string(from: date)
        return formattedDate
    }
    
    func formartTimeForTaskCreationTime(date: Date) -> String {
        let formattedDate = taskCreationTimeFormatter.string(from: date)
        return formattedDate
    }
    
    func formartDateForTaskCreationDate(date: Date) -> String {
        let formattedDate = taskCreationDateFormatter.string(from: date)
        return formattedDate
    }
}
