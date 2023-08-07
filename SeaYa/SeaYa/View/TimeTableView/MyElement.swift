//
//  MyElement.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/08/07.
//

import Foundation

struct myElement : Hashable, Identifiable{
    var id : UUID
    var indexX : Int
    var indexY : Int
    var value : Int
    var myLocation : MyPoint?
    var isSelected : Bool = false
}

struct MyPoint: Hashable {
    let x: CGFloat
    let y: CGFloat
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    init(_ cgRect : CGRect?){
        self.x = cgRect?.origin.x ?? 0
        self.y = cgRect?.origin.y ?? 0
    }
    
    init(_ cgRect : CGRect?, _ canvasSize : CGRect?){
        self.x = (cgRect?.origin.x ?? 0) - (canvasSize?.origin.x ?? 0)
        self.y = (cgRect?.origin.y ?? 0) - (canvasSize?.origin.y ?? 0)
    }
}

extension myElement{
    static var example = [
        [
            myElement(
                id: UUID(),
                indexX: 0,
                indexY: 0,
                value: 00),
            myElement(
                id: UUID(),
                indexX: 1,
                indexY: 0,
                value: 10),
            myElement(
                id: UUID(),
                indexX: 2,
                indexY: 0,
                value: 20),
            myElement(
                id: UUID(),
                indexX: 3,
                indexY: 0,
                value: 30)
        ],[
            myElement(
                id: UUID(),
                indexX: 0,
                indexY: 1,
                value: 01),
            myElement(
                id: UUID(),
                indexX: 1,
                indexY: 1,
                value: 11),
            myElement(
                id: UUID(),
                indexX: 2,
                indexY: 1,
                value: 11),
            myElement(
                id: UUID(),
                indexX: 3,
                indexY: 1,
                value: 11),
            ]
        ]
}

