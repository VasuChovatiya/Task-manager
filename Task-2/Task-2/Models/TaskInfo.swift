//
//  TaskInfo.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 12/2/23.
//

import Foundation
import RealmSwift

enum TaskCategory: String, CaseIterable, Identifiable{
    case home = "Home"
    case work = "Work"
    
    var id: String {
        return self.rawValue
    }
}

enum TaskRepeatMode: String, CaseIterable, Identifiable{
    case daily = "Daily"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String {
        return self.rawValue
    }
}

class TaskInfo: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var taskName: String = ""
    @objc dynamic var taskDescription: String = ""
    @objc dynamic var taskCategory: String = ""
    @objc dynamic var taskDate: String = ""
    @objc dynamic var repeatMode: String = ""
    @objc dynamic var isCompleted: Bool = false
   
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    var taskCategoryObj: TaskCategory? {
        return TaskCategory(rawValue: self.taskCategory)
    }
    
    var taskDateObj: Date? {
        return self.taskDate.getDateWithFormate(formate: Application.globalDateTimeFormat, timezone: currentTimeZoneString())
    }
    
    var repeatationModeObj: TaskRepeatMode? {
        return TaskRepeatMode(rawValue: self.repeatMode)
    }
}



extension TaskInfo {
    static var mockData: TaskInfo {
        let temp = TaskInfo()
        temp.taskName = "Do Home work"
        temp.taskDescription = "lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
        temp.taskCategory = TaskCategory.home.rawValue
        temp.taskDate = "22 Dec, 2023"
        temp.repeatMode = TaskRepeatMode.daily.rawValue
        temp.isCompleted = false
        return temp
    }
    
    
    static var  dummyData: [TaskInfo] {
        var temp: [TaskInfo] = []
        for _ in 1...10 {
            let task = TaskInfo()
            task.taskName = "Dummy Task"
            task.taskDescription = "This is a dummy task."
            task.taskCategory = TaskCategory.allCases.randomElement()!.rawValue
            task.taskDate = "2023-12-31" // Provide a valid date format
            task.repeatMode = TaskRepeatMode.allCases.randomElement()!.rawValue
            task.isCompleted = Bool.random()

            temp.append(task)
        }

        return temp
    }
    
}

