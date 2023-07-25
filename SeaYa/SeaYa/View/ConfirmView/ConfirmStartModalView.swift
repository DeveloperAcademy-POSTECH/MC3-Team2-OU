//
//  ConfirmStartView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/21.
//

import SwiftUI

struct ConfirmStartModalView: View {
    @Binding var selectedDate : Date
    var title : String
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(hex: "#D3D3D3"))
                .frame(width:34, height:5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 26, trailing: 0))
            Text(title).headline(textColor: .primaryColor).padding(.bottom, 43)
            HStack{
                DatePicker(selection: $selectedDate,displayedComponents: [.hourAndMinute], label: {EmptyView()})
                    .onAppear{
                        UIDatePicker.appearance().minuteInterval = 10
                    }
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
        }
    }
}

struct ConfirmStartModalView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmStartModalTestView().environment(\.locale, .init(identifier: "ko"))
    }
}

struct ConfirmStartModalTestView : View{
    @State private var isModalPresented = true
    @State private var selectedDate = Date(timeIntervalSinceNow: 60*60*24*2)
    var body: some View{
        
        let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: selectedDate)
        VStack{
            HStack{
                Text("\(time.year!)")
                Text("\(time.month!)")
                Text("\(time.day!)")
                Text("\(time.hour!)")
                Text("\(time.minute!)")
            }
            Button("Show Modal"){
                isModalPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isModalPresented, content: {
            ConfirmStartModalView(selectedDate : $selectedDate, title: "시작 시간")
                .presentationDetents([.height(354)])
                .presentationCornerRadius(32)
        })
    }
}
