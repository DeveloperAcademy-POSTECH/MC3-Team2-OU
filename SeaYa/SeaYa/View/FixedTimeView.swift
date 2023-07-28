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
    @State private var fixedTime = ""
    @State var fixedTimeViewModel = FixedTimeViewModel()
    @State var showSettingViewModal = false
    @State var selectedIndex = -1
    @StateObject var state = FixedTimeViewState()

    var body: some View {
        VStack {
            Section(
                content: {
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
                    
                    Button(
                        action: {
                            state.isUpdate = false
                            showSettingViewModal = true
                            fixedTimeViewModel.fixedTimeModels.append(FixedTimeModel())
                            if fixedTimeViewModel.fixedTimeModels.count >= 1 {
                                selectedIndex = fixedTimeViewModel.fixedTimeModels.count-1
                            }
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
                    
                    Spacer()

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
                },
                header : {
                    HStack{
                        Text("고정적인 일정을 \n추가해주세요").title(textColor: .primary).frame(alignment: .leading)
                        Spacer()
                    }
                    .padding(.leading, 22)
                }
            )
        }
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
