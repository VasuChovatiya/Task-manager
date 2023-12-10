//
//  TaskCellView.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 12/2/23.
//

import SwiftUI

struct TaskCellView: View {
    //MARK: - Properties
    
    var info: TaskInfo
    var onBtnComplete: (() -> ())
    
    //MARK: - Body
    var body: some View {
        HStack(alignment: .center, spacing: 15.0) {
            
            if info.isCompleted == true {
                ZStack {
                    Color.blue
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.White)
                        .frame(width: 20, height: 20)
                    
                }
                .clipShape(Circle())
                .frame(width: 25, height: 25)
                
            } else {
                Button {
                    onBtnComplete()
                } label: {
                    Circle()
                        .stroke(Color.gray, lineWidth: 2.0)
                        .frame(width: 25, height: 25)
                }
            }
            
            
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text(info.taskName)
                    .strikethrough(info.isCompleted)
                    .foregroundColor(Color.Black)
                    .font(.Roboto_Bold(of: 18))
                
                if let date = info.taskDateObj?.getDateStringWithFormate(Application.dateAndTimeformatForDisplay, timezone: currentTimeZoneString()) {
                    Text(date)
                        .strikethrough(info.isCompleted)
                        .foregroundColor(Color.gray)
                        .font(.Roboto_Medium(of: 12))
                }
                
                
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5.0) {
                
                
                Text("\(info.taskCategory)")
                    .strikethrough(info.isCompleted)
                    .foregroundColor(Color.Black)
                    .font(.Roboto_Medium(of: 14))
                
                
                Text("\(info.repeatMode)")
                    .strikethrough(info.isCompleted)
                    .foregroundColor(Color.Black)
                    .font(.Roboto_Medium(of: 14))
                
            }
            
        }
        .padding(15)
        .background {
            
            ZStack {
                if info.isCompleted == true {
                    Color.gray.opacity(0.3)
                } else {
                    Color.White
                }
                
            }
            .cornerRadius(15)
            .shadow(radius: 5.0)
        }
        .padding(.horizontal, 20)
        
    }
    
}


//MARK: - Preview

struct TaskCellView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellView(info: TaskInfo.mockData) {
            
        }
    }
}
