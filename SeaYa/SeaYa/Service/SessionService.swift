//
//  SessionService.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/08/30.
//

import Foundation

class SessionService : ObservableObject{
    // 각 멤버의 닉네임, 달력 일정이 들어가 있어야함
    @Published var groupInfo: GroupInfo?
        
    //로딩 세션 -> 세션 정보를 받아온다.

    //세션을 쓴다(수정한다)(삭제한다)//
    func writeSession(){
        
    }
    
    //세션을 읽는다
    func readSession(){
        
    }
}
