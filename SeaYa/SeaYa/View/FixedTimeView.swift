//
//  FixedTimeView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct FixedTimeView: View {
    @Binding var isFixedTimeSettingCompleted: Bool
    @State var fixedTimeViewModel = FixedTimeViewModel()
    @State var showSettingViewModal = false
    @State var selectedIndex = 0

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
                            isFixedTimeSettingCompleted = true
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
            SettingView(
                fixedTimeViewModel: $fixedTimeViewModel,
                showSettingViewModal: $showSettingViewModal,
                selectedIndex : $selectedIndex,
                onDelete: {id in
                    fixedTimeViewModel.deleteItem(withID: id)
            })
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
