//
//  DateOks.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/13.
//

import Foundation

struct TimeOks : Hashable, Codable{
    let timeInt : Int // Date.timeIntervalSince1970 형을 1800초로 나눈 값
    let Oks : Int}

struct ListUpViewResult : Codable{
    let result : [[TimeOks]]
    
    init(){
        self.result = [[TimeOks]()]
    }
    
    init(result : [[TimeOks]]){
        self.result = result
    }
}
