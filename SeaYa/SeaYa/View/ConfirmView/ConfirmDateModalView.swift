//
//  ConfirmDateModalView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/21.
//

import SwiftUI

struct ConfirmDateModalView: View {
    @Binding var selectedEvent: DateEvent
    @Binding var showDateModal: Bool
    @State private var selectedButtons: [(week: Int, day: Int)] = []
    @State var selectedDate = [Date]()

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(hex: "#D3D3D3"))
                .frame(width: 34, height: 5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 26, trailing: 0))

            Text("날짜")
                .headline(textColor: .primaryColor)
                .padding(.bottom, 43)

            CalendarView(selectedDate: $selectedDate, isMultiDatesAvailable: false, seletDate: selectedEvent.startDate)
                .onChange(
                    of: selectedDate,
                    perform: { value in
                        selectedEvent.startDate.updateDay(value.first ?? Date())
                        selectedEvent.endDate.updateDay(value.first ?? Date())
                        showDateModal = false
                    }
                )
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 60, trailing: 30))
    }
}

struct ConfirmDateModalTestView: View {
    @State private var isModalPresented = true
    @State private var selectedEvent = DateEvent(
        title: "Test Event",
        startDate: Date(),
        endDate: Date(timeIntervalSinceNow: 60 * 60 * 3 + 60 * 30)
    )
    var body: some View {
        VStack {
            Text(String(describing: selectedEvent.startDate))
            Text(String(describing: selectedEvent.endDate))
            Button("Show Modal") {
                isModalPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isModalPresented, content: {
            ConfirmDateModalView(selectedEvent: $selectedEvent, showDateModal: .constant(true), selectedDate: [selectedEvent.startDate.toDate()])
                .presentationDetents([.height(354)])
                .presentationCornerRadius(32)
        })
    }
}

#Preview{
    ConfirmDateModalTestView()
}
