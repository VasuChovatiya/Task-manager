//
//  TaskListingViewModel.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 12/2/23.
//

import UIKit

class TaskListingViewModel: NSObject, ObservableObject {
    //MARK: - Properties
    
    @Published var arrTasks: [TaskInfo] = []
    var isForMockData: Bool = false
    

    //MARK: - Init
    
    
    init(isForMockData: Bool = false) {
        super.init()
        if isForMockData == true {
            self.isForMockData = isForMockData
            fetchMockData()
        }
    }
    
    
    //MARK: - Functions
    
    
    func fetchTasks() {
        arrTasks.removeAll()
        arrTasks.append(contentsOf: DBManager.shared.getDataFromDB(object: TaskInfo.self).toArray(TaskInfo.self))
        arrTasks = arrTasks.sorted(by: { info1, info2 in
            return info1.taskDateObj ?? Date() > info2.taskDateObj ?? Date()
        })
    }
    
    func refreshData() {
        arrTasks = DBManager.shared.getDataFromDB(object: TaskInfo.self).toArray(TaskInfo.self)
        arrTasks = arrTasks.sorted(by: { info1, info2 in
            return info1.taskDateObj ?? Date() > info2.taskDateObj ?? Date()
        })
    }
    
    
    func markTaskAsComplete(info: TaskInfo) {
        // for disabling notifications
        //https://stackoverflow.com/questions/71391214/how-to-remove-pending-notification-request-when-using-uuidstring-as-identifier-s
        NotificationManager.shared.removePendingNotficationRequests(for: info.id) { status in
            DispatchQueue.main.async {
                DBManager.shared.update(info, with: ["isCompleted": true])
            }
            
        }
        
    }
        
    func deleteTaskFromDatabase(info: TaskInfo) -> Bool {
        
        
        DBManager.shared.delete(info)
    }
    
    
    // MARK: -  Deinit
    
    deinit {
        DLog("AddTaskViewModel Deinited")
    }

}



//MARK: - MockData

extension TaskListingViewModel {
    private func fetchMockData() {
        arrTasks = TaskInfo.dummyData
    }
}
