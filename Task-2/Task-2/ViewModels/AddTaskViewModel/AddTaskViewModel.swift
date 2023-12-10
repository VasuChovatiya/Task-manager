//
//  AddTaskViewModel.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 12/2/23.
//

import UIKit

class AddTaskViewModel: NSObject, ObservableObject {
    
    // MARK: -  Properties
    @Published var taskName: String = ""
    @Published var taskDescription: String = ""
    @Published var taskCatergory: TaskCategory = .home
    @Published var taskDate: Date = Date()
    @Published var taskDateString: String = ""
    //    @Published var taskTime: Date = Date()
    //    @Published var taskTimeString: String = ""
    @Published var taskRepeatMode: TaskRepeatMode = .monthly
    
    
    // MARK: -  LifeCycle
    override init() {
        super.init()
        clearAllValues()
    }
    
    
    // MARK: -  Functions
    func validateFields() -> (isValid: Bool, msg: String) {
        if taskName.trimmed().isEmpty {
            return (false, "Enter task name")
        } else if taskDescription.trimmed().isEmpty {
            return (false, "Enter description")
        } else if taskDateString.trimmed().isEmpty {
            return (false, "Select date & time")
        } else {
            return (true, "")
        }
    }
    
    
    func saveTask(onCompletion: @escaping (_ status: Bool, _ msg: String) -> ()) {
        let info = TaskInfo()
        info.taskName = self.taskName.trimmed()
        info.taskDescription = self.taskName.trimmed()
        info.taskDate = self.taskDateString
        info.taskCategory = self.taskCatergory.rawValue
        info.repeatMode = self.taskRepeatMode.rawValue
        info.isCompleted = false
        
        switch taskRepeatMode {
        case .daily:
            NotificationManager.shared.scheduleDailyNotification(id: info.id, title: info.taskName, body: info.taskDescription, date: self.taskDate) { status in
                if status == true {
                    DispatchQueue.main.async {
                        DBManager.shared.store(info)
                    }
                    
                    onCompletion(true, "")
                } else {
                    onCompletion(false, "task save unable save notfications")
                    
                }
            }
        case .monthly:
            NotificationManager.shared.scheduleMonthlyNotification(id: info.id, title: info.taskName, body: info.taskDescription, date: self.taskDate) { status in
                if status == true {
                    DispatchQueue.main.async {
                        DBManager.shared.store(info)
                    }
                    
                    onCompletion(true, "")
                } else {
                    onCompletion(false, "task save unable save notfications")
                    
                }
            }
        case .yearly:
            NotificationManager.shared.scheduleYearlyNotification(id: info.id, title: info.taskName, body: info.taskDescription, date: self.taskDate) { status in
                if status == true {
                    DispatchQueue.main.async {
                        DBManager.shared.store(info)
                    }
                    
                    onCompletion(true, "")
                } else {
                    onCompletion(false, "task save unable save notfications")
                    
                }
            }
        }
    }
    
    private func clearAllValues() {
        self.taskName = ""
        self.taskDescription = ""
        self.taskDateString = ""
        self.taskDate = Date()
        self.taskCatergory = .home
        self.taskRepeatMode = .daily
    }
    
   
    
    
    
    // MARK: -  Deinit
    
    deinit {
        DLog("AddTaskViewModel Deinited")
    }
}

