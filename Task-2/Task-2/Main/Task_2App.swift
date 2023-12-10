//
//  Task_2App.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 01/12/23.
//

import SwiftUI

@main
struct Task_2App: App {
    var body: some Scene {
        WindowGroup {
            TaskListingView(viewModel: TaskListingViewModel())
        }
    }
}
