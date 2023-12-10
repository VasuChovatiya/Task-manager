//
//  TaskListingView.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 12/2/23.
//

import SwiftUI

struct TaskListingView: View {
    //MARK: - Properties
    @StateObject var viewModel: TaskListingViewModel
    @State private var isLoading: Bool = true
    @State private var showAllCompletedTask: Bool = true
    @State private var showAllPendingTask: Bool = true
    @State private var goToAddTask: Bool = false
    @State private var showSettingAlert: Bool = false
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            
            NavigationView(content: {
                VStack(alignment: .center, spacing: 40.0, content: {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center, spacing: 15.0, content: {
                            if viewModel.arrTasks.isEmpty == false {
                                taskListingView()
                                
                                completedTaskListingView()
                            } else {
                                Spacer()
                                Text("No Task Found")
                                    .font(.Roboto_Bold(of: 25))
                                    .foregroundStyle(Color.Black)
                                Spacer()
                                
                            }
                            
                        })
                        
                    }
                    .onAppear {
                        isLoading = true
                        if viewModel.isForMockData == false {
                            DLog("Fetching  Tasks")
                            viewModel.fetchTasks()
                        }
                        isLoading = false
                    }
                })
                .navigationTitle("Tasks")
                .toolbar {
                    
                    Button(action: {
                        goToAddTask.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.blue)
                    })
                    
                    NavigationLink(isActive: $goToAddTask) {
                        AddTaskView(goToHomeScreen: $goToAddTask)
                    } label: {
                        EmptyView()
                    }
                }
                .navigationBarTitleDisplayMode(.large)
                
            })
           
            
            if isLoading == true {
                ZStack(content: {
                    Color.Black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    
                    ZStack(alignment: .center, content: {
                        VStack(content: {
                            ProgressView()
                                .scaleEffect(2.0)
                            
                            Text("Fetching Tasks")
                        })
                        .padding(25)
                        .background {
                            Color.White
                        }
                        .cornerRadius(15)
                    })
                })
            }
            
        }
        .showSettingAlert(isPresented: $showSettingAlert)
        .onAppear{
            printDocDirectory()
            NotificationManager.shared.getAuthorizeStatus { status in
                if status == .authorized || status == .provisional {
                    DLog("Permission Granted")
                } else {
                    NotificationManager.shared.requestAuthentication { status in
                        if status == true {
                            DLog("Permission Granted")
                        } else {
                            showSettingAlert = true
                            DLog("Permsision for notifcation not Granted")
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    //MARK: - @ViewBuilders
    @ViewBuilder
    private func taskListingView() -> some View {
        
        
        VStack(alignment: .center, spacing: 15.0) {
            HStack(alignment: .center, spacing: 0.0) {
                Text("Pending Tasks")
                    .foregroundColor(Color.Black)
                    .font(.Roboto_Bold(of: 20))
                Spacer()
                
                Button {
                    withAnimation(.linear) {
                        showAllPendingTask.toggle()
                    }
                } label: {
                    Image(systemName: showAllPendingTask == true ? "chevron.up" : "chevron.down")
                        .font(.Roboto_Bold(of: 20))
                        .foregroundColor(Color.Black)
                }
                
                
            }
            .padding(20)
            
            if showAllPendingTask == true {
                ForEach(viewModel.arrTasks, id: \.id) { info in
                    if info.isCompleted == false {
                        TaskCellView(info: info) {
                            isLoading = true
                            viewModel.markTaskAsComplete(info: info)
                            isLoading = false
                            viewModel.refreshData()
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    
    @ViewBuilder
    private func completedTaskListingView() -> some View {
        
        VStack(alignment: .center, spacing: 15.0) {
            HStack(alignment: .center, spacing: 0.0) {
                Text("Completed Tasks")
                    .foregroundColor(Color.Black)
                    .font(.Roboto_Bold(of: 20))
                Spacer()
                
                Button {
                    withAnimation(.linear) {
                        showAllCompletedTask.toggle()
                    }
                } label: {
                    Image(systemName: showAllCompletedTask == true ? "chevron.up" : "chevron.down")
                        .font(.Roboto_Bold(of: 20))
                        .foregroundColor(Color.Black)
                }
                
                
            }
            .padding(20)
            
            if showAllCompletedTask == true {
                ForEach(viewModel.arrTasks, id: \.id) { info in
                    if info.isCompleted == true {
                        TaskCellView(info: info) {
                            DLog("Alread marked as Completed")
                        }
                    }
                }
            }
            
        }
        
    }
    
}


//MARK: - Preview

struct TaskListingView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListingView(viewModel: TaskListingViewModel(isForMockData: true))
    }
}
