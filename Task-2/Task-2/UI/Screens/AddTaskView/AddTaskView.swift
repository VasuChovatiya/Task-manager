//
//  AddTaskView.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 12/2/23.
//

import SwiftUI

struct AddTaskView: View {
    //MARK: - Properties
    @Binding var goToHomeScreen: Bool
    @State private var toast: Toast? = nil
    @State private var isDisable: Bool = true
    @State private var showSettingAlert: Bool = false
    
    @StateObject private var viewModel: AddTaskViewModel = AddTaskViewModel()
    
    //MARK: - Body
    
    var body: some View {
        
        VStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30.0) {
                    taskNameField()
                        .padding(.top, 25)
                    
                    taskDescriptionField()
                    
                    taskCategorySegmentView()
                    
                    
                    dateAndTimeSelcetionView()
                    
                    
                    repeatModeSegmentView()
                    
                    Spacer()
                    
                    cancelAndSaveButtonView()
                }
                .padding(.horizontal, 20)
            }.navigationTitle("Add Task")
                .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
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
        .showSettingAlert(isPresented: $showSettingAlert)
        .toastView(toast: $toast)
    }
    
    
    //MARK: - @ViewBuilder
    
    @ViewBuilder
    private func taskNameField() -> some View {
        
        HStack(alignment: .center, spacing: 10.0, content: {
            
            Text("Task Name")
                .foregroundStyle(Color.Black)
                .font(.Roboto_Medium(of: 15))
            
            
            ZStack(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 2.0)
                    .foregroundColor(Color.clear.opacity(0.0))
                //                                .stroke(Color.gray, lineWidth: 1.0)
                //                                .fill(Color.clear.opacity(0.0))
                
                
                
                ZStack(alignment: .leading, content: {
                    
                    if viewModel.taskName.trimmed().isEmpty == true {
                        Text("Enter Task Name")
                            .foregroundStyle(Color.gray.opacity(0.8))
                            .padding(5)
                    }
                    
                    TextField("", text: $viewModel.taskName)
                        .tint(Color.gray)
                        .padding(5)
                    
                    
                })
                .padding(5)
                
            })
            .frame(height: 40)
        })
        .onChange(of: viewModel.taskName) { _ in
            isDisable = !viewModel.validateFields().isValid
        }
    }
    
    
    @ViewBuilder
    private func taskDescriptionField() -> some View {
        HStack(alignment: .center, spacing: 10.0, content: {
            
            Text("Task Desc")
                .foregroundStyle(Color.Black)
                .font(.Roboto_Medium(of: 15))
            
            ZStack(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 2.0)
                    .foregroundColor(Color.clear.opacity(0.0))
                //                                .stroke(Color.gray, lineWidth: 1.0)
                //                                .fill(Color.clear.opacity(0.0))
                
                
                
                ZStack(alignment: .leading, content: {
                    
                    if viewModel.taskDescription.trimmed().isEmpty == true {
                        Text("Enter Task Desc")
                            .foregroundStyle(Color.gray.opacity(0.8))
                            .padding(5)
                    }
                    
                    TextField("", text: $viewModel.taskDescription)
                        .tint(Color.gray)
                        .padding(5)
                    
                    
                })
                .padding(5)
                
            })
            .frame(height: 40)
        })
        .onChange(of: viewModel.taskDescription) { _ in
            isDisable = !viewModel.validateFields().isValid
        }
    }
    
    
    @ViewBuilder
    private func taskCategorySegmentView() -> some View {
        
        HStack(alignment: .center, spacing: 10.0, content: {
            Text("Task Category")
                .foregroundStyle(Color.Black)
                .font(.Roboto_Medium(of: 15))
            
            
            SegmentControlView(segments: TaskCategory.allCases, selected: $viewModel.taskCatergory, titleNormalColor: Color.Black, titleSelectedColor: Color.White , selectedBgColor: Color.gray, bgColor: Color.gray.opacity(0.5), animation: .easeInOut) { item in
                Text(item.rawValue)
                    .font(.Roboto_Bold(of: 16))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            } background: {
                RoundedRectangle(cornerRadius: 8)
            }
            .frame(height: 40)
        })
        
    }
    
    
    @ViewBuilder
    private func dateAndTimeSelcetionView() -> some View {
        HStack(alignment: .center, spacing: 10.0, content: {
            Text("Select Date And time")
                .foregroundStyle(Color.Black)
                .font(.Roboto_Medium(of: 15))
            
            Spacer()
            
            DatePicker("", selection: $viewModel.taskDate)
                .labelsHidden()
                .colorMultiply(Color.Black)
            //            .datePickerStyle(.wheel)
                .clipped()
                .onAppear{
                    viewModel.taskDateString = viewModel.taskDate.getDateStringWithFormate(Application.globalDateTimeFormat, timezone: currentTimeZoneString())
                    DLog("task Date and time : - \(viewModel.taskDateString)")
                }
                .onChange(of: viewModel.taskDate) { newValue in
                    
                    viewModel.taskDateString = newValue.getDateStringWithFormate(Application.globalDateTimeFormat, timezone: currentTimeZoneString())
                    DLog("task Date and time : - \(viewModel.taskDateString)")
                }
            
        })
    }
    
    
    @ViewBuilder
    private func repeatModeSegmentView() -> some View {
        HStack(alignment: .center, spacing: 10.0, content: {
            Text("Repeat Mode")
                .foregroundStyle(Color.Black)
                .font(.Roboto_Medium(of: 15))
            
            
            SegmentControlView(segments:  TaskRepeatMode.allCases, selected: $viewModel.taskRepeatMode, titleNormalColor: Color.Black, titleSelectedColor: Color.White , selectedBgColor: Color.gray, bgColor: Color.gray.opacity(0.5), animation: .easeInOut) { item in
                Text(item.rawValue)
                    .font(.Roboto_Bold(of: 15))
                    .padding(.horizontal, 5.0)
                    .padding(.vertical, 8)
            } background: {
                RoundedRectangle(cornerRadius: 8)
            }
            .frame(height: 40)
        })
    }
    
    
    @ViewBuilder
    private func cancelAndSaveButtonView() -> some View {
        HStack(alignment: .center, content: {
            Button(action: {
                goToHomeScreen.toggle()
            }, label: {
                Text("Cancel")
            })
            .buttonStyle(FilledButtonStyle(fillColor: Color.red, textColor: .White , height: 45))
            
            Button(action: {
                onBtnSave()
            }, label: {
                Text("Save")
            })
            .disabled(isDisable)
            .buttonStyle(FilledButtonStyle(fillColor: Color.green, textColor: .White , height: 45, isDisabled: isDisable))
        })
    }
    
    //MARK: - Functions
    private func onBtnSave() {
        viewModel.saveTask() { status, msg in
            if status == false {
                toast = Toast(style: .error, message: msg, duration: 1.0)
                goToHomeScreen.toggle()
            } else {
                toast = Toast(style: .success, message: "Task added", duration: 1.0)
                goToHomeScreen.toggle()
            }
        }
    }
    
    
}


//MARK: - Preview

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(goToHomeScreen: .constant(false))
    }
}
