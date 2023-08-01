//
//  FixedTimeView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

class FixedTimeViewState: ObservableObject {
    @Published var isUpdate: Bool? = nil
}

struct FixedTimeView: View {
    @Binding var isFixedTimeSettingCompleted: Bool
    @State var fixedTimeViewModel = FixedTimeViewModel()
    @State var showSettingViewModal = false
    @State var selectedIndex = -1
    @StateObject var state = FixedTimeViewState()
    private let fixedTimeKey = "FixedTimeKey"
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let itemWidth = screenWidth / 3 - 20
            VStack {
                HStack {
                    Rectangle()
                        .foregroundColor(Color.primaryColor)
                        .frame(width: itemWidth, height: 3)
                        .cornerRadius(2)
                    Rectangle()
                        .foregroundColor(Color.primaryColor)
                        .frame(width: itemWidth, height: 3)
                        .cornerRadius(10)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: itemWidth, height: 3)
                        .cornerRadius(10)
                }
                Text("반복되는 일정을\n추가해주세요")
                    .title(textColor: Color.textColor)
                    .padding(.vertical, 30)
                    .frame(width: 340, alignment: .leading)
                if fixedTimeViewModel.fixedTimeModels.count > 0 {
                    ScrollView{
                        VStack{
                            ForEach(Array(fixedTimeViewModel.fixedTimeModels.enumerated()), id: \.offset){ index,
                                fixedTimeModel in
                                Button(
                                    action: {
                                        state.isUpdate = true
                                        showSettingViewModal = true
                                        selectedIndex = index
                                    },
                                    label: {
                                        FixedTimeElementView(fixedTimeModel: fixedTimeModel)
                                    }
                                )
                            }
                        }
                    }
                    .scaledToFit()
                }
                Button(
                    action: {
                        state.isUpdate = false
                        showSettingViewModal = true
                        fixedTimeViewModel.fixedTimeModels.append(FixedTimeModel())
                        if fixedTimeViewModel.fixedTimeModels.count >= 1 {
                            selectedIndex = fixedTimeViewModel.fixedTimeModels.count-1
                        }
                    }, label: {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color.white)
                            Text("반복일정 추가")
                                .body(textColor: .primaryColor)
                                .padding(.leading, 18)
                        }
                        .frame(height: 48)
                    }
                )
                Spacer(minLength: 0)
                
                BigButton_Blue(
                    title: "다음",
                    action: {
                        isFixedTimeSettingCompleted = true
                        fixedTimeViewModel.buttonClicked()
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(fixedTimeViewModel.fixedTimeModels) {
                            UserDefaults.standard.set(encodedData, forKey: fixedTimeKey)
                        }
                    }
                )
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $showSettingViewModal, content: {
                if let isUpdate = state.isUpdate {
                    SettingView(
                        fixedTimeViewModel: $fixedTimeViewModel,
                        showSettingViewModal: $showSettingViewModal,
                        selectedIndex : $selectedIndex,
                        tempFixedTimeModel : selectedIndex >= 0 ? fixedTimeViewModel.fixedTimeModels[selectedIndex] : FixedTimeModel(),
                        isUpdate: isUpdate,
                        onDelete: {id in
                            fixedTimeViewModel.deleteItem(withID: id)
                        })
                    .presentationCornerRadius(32)
                } else {
                    EmptyView()
                }
            })
            .background(Color.backgroundColor)
        }
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
