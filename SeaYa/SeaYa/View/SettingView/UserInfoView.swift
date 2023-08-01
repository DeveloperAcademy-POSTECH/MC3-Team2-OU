//
//  UserInfoView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/28.
//

import SwiftUI

class EditFixedTimeViewState: ObservableObject {
    @Published var isUpdate: Bool? = nil
}

struct UserInfoView: View {
    @State var fixedTimeViewModel = FixedTimeViewModel()
    @State var showSettingViewModal = false
    @State var selectedIndex = 0
    @EnvironmentObject var userData: UserData
    @StateObject var state = EditFixedTimeViewState()
    @Environment(\.presentationMode) private var presentationMode
    private let fixedTimeKey = "FixedTimeKey"
    let userInfoRepository = UserInfoRepository.shared
    
    init() {
          if let data = UserDefaults.standard.data(forKey: fixedTimeKey) {
              let decoder = JSONDecoder()
              if let decodedData = try? decoder.decode([FixedTimeModel].self, from: data) {
                  self._fixedTimeViewModel = State(initialValue: FixedTimeViewModel(decodedData))
              } else {
                  self._fixedTimeViewModel = State(initialValue: FixedTimeViewModel())
              }
          } else {
              self._fixedTimeViewModel = State(initialValue: FixedTimeViewModel())
          }
      }
    var body: some View {
        NavigationStack {
            VStack{
                Text("프로필 설정")
                    .caption(textColor: Color.unactiveColor)
                    .padding(EdgeInsets(top: 30, leading: 25, bottom: 5, trailing: 25))
                    .frame(width: 358, alignment: .leading)
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.white)
                    HStack(spacing : 25){
                        Image(userData.characterImageName)
                            .resizable()
                            .frame(width: 70, height: 70)
                        VStack(alignment: .leading){
                            Text(userData.nickname).body(textColor: Color.textColor)
                            Button(action: {
                            }, label: {
                                NavigationLink(
                                    destination: {
                                        NicknameEditView().environmentObject(userData)
                                    }, label:{
                                        Text("프로필 편집").body(textColor: Color.primaryColor)
                                    })
                            })
                        }
                    }.padding(EdgeInsets(top: 17, leading: 19, bottom: 17, trailing: 167))
                        .frame(alignment: .topLeading)
                }.frame(width: 358, height: 104)
                Text("고정시간 설정")
                    .caption(textColor: Color.unactiveColor)
                    .padding(EdgeInsets(top: 30, leading: 25, bottom: 5, trailing: 25))
                    .frame(width: 358, alignment: .leading)
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
                        print("here!")
                        print(String(describing: fixedTimeViewModel.fixedTimeModels.first!.category))
                        let encoder = JSONEncoder()
                                if let encodedData = try? encoder.encode(fixedTimeViewModel.fixedTimeModels) {
                                    UserDefaults.standard.set(encodedData, forKey: fixedTimeKey)
                                }
                        presentationMode.wrappedValue.dismiss()
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
            .frame(alignment: .leading)
            .background(Color.backgroundColor)
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
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData() // UserData 객체를 생성하여 nickname 설정
        
        return UserInfoView().environmentObject(userData)
    }
}

