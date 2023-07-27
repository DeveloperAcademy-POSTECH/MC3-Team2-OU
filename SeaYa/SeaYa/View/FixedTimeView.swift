//
//  FixedTimeView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct FixedTimeView: View {
    @Binding var isFixedTimeSettingCompleted: Bool
    @State private var fixedTime = ""
    @State var fixedTimeViewModel = FixedTimeViewModel()
    @State var showSettingViewModal = false
    @State var selectedElement = FixedTimeModel()

    var body: some View {
        VStack {
            ForEach(fixedTimeViewModel.fixedTimeModels, id: \.self){ fixedTimeModel in
                Button(
                    action: {
                        showSettingViewModal = true
                        selectedElement = fixedTimeModel
                    },
                    label: {
                       FixedTimeElementView(fixedTimeModel: fixedTimeModel)
                   }
                )
            }
            
            Button(
                action: {
                    showSettingViewModal = true
                    selectedElement = FixedTimeModel()
                    fixedTimeViewModel.fixedTimeModels.append(selectedElement)
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.white)
                        HStack{
                            Text("고정일정 추가").body(textColor: .primaryColor)
                            Spacer()
                        }.padding(.leading, 18)
                    }.frame(width: 358,height: 47)
                }
            )
            

            Button(
                action: {
                    if !fixedTime.isEmpty {
                        isFixedTimeSettingCompleted = true
                    }
                },
                label: {
                    Text("확인")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSettingViewModal, content: {
            EmptyView()
                .presentationCornerRadius(32)
        })
        .background(Color.backgroundColor)
    }
}

struct FixedTimeTestView : View{
    @State var isFixedTimeSettingCompleted = false
    @State var fixedTimeViewModel = FixedTimeViewModel([
        FixedTimeModel(),
        FixedTimeModel(),
        FixedTimeModel()
    ])
    
    var body: some View{
        FixedTimeView(
            isFixedTimeSettingCompleted: $isFixedTimeSettingCompleted,
            fixedTimeViewModel: fixedTimeViewModel
        )
    }
}

struct FixedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        FixedTimeTestView()
    }
}
