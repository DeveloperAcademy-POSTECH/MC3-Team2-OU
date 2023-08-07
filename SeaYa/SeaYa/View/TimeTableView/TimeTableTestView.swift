//
//  TimeTableTestView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/08/07.
//

import SwiftUI

struct TimeTableTestView: View {
    @State var mElement = myElement.example
    @State var selectedCollection : [[Int]] = [[]]
    @State var xArray : [CGFloat] = []
    @State var yArray : [CGFloat] = []
    @State var startPoint : CGPoint?
    @State var endPoint : CGPoint?
    @State var canvasSize : CGRect?
    @State var width : CGFloat?
    @State var height : CGFloat?
    @State var xEndIndex : Int?
    @State var yEndIndex : Int?
    @State var xStartIndex : Int?
    @State var yStartIndex : Int?
    @State var isFirstSelectd : Bool?
    var body: some View {
        ZStack{
            VStack{
                Text(String(describing: xArray))
                Text(String(describing: yArray))
                ZStack{
                    //색칠하기
                    HStack(spacing: 0){
                        ForEach(Array(mElement.enumerated()), id :\.offset){xindex, elements in
                            VStack(spacing: 0){
                                ForEach(Array(elements.enumerated()), id: \.offset){yindex, value in
                                    ZStack{
                                        Rectangle()
                                            .fill(value.isSelected ? Color.red : Color.clear)
                                    }
                                    .background(
                                        GeometryReader{ geo in
                                            Color.clear.onAppear{
                                                let eachLocation = MyPoint( geo.frame(in: .global), canvasSize)
                                                mElement[xindex][yindex].myLocation = eachLocation
                                                if xindex == 0 {
                                                    yArray.append((geo.frame(in: .global).origin.y))
                                                    if yindex == 0 {
                                                        width = geo.frame(in:.global).width
                                                        height = geo.frame(in:.global).height
                                                    }
                                                }
                                                if yindex == 0 {
                                                    xArray.append((geo.frame(in: .global).origin.x))
                                                }
                                                if xArray.count == mElement.count &&
                                                    yArray.count == mElement[xindex].count {
                                                    xArray.sort()
                                                    yArray.sort()
                                                    
                                                    xArray = xArray.map{$0 - (xArray.min() ?? 0)}
                                                    yArray = yArray.map{$0 - (yArray.min() ?? 0)}
                                                }
                                            }
                                        })
                                    .frame(width: 80, height: 50)
                                }
                            }
                        }
                    }.background(GeometryReader{geo in Color.clear.onAppear{
                        canvasSize = geo.frame(in: .global)
                    }})
                    RectangleView(startPoint: startPoint, endPoint: endPoint,
                                  xArray: xArray,
                                  yArray: yArray,
                                  width: width,
                                  height: height,
                                  isSelected: isFirstSelectd
                    ).frame(width: canvasSize?.width, height: canvasSize?.height)
                    HStack(spacing: 0){
                        ForEach(Array(mElement.enumerated()), id :\.offset){xindex, elements in
                            VStack(spacing: 0){
                                ForEach(Array(elements.enumerated()), id: \.offset){yindex, value in
                                    ZStack{
                                        Text(String(describing: value.value))
                                    }
                                    .frame(width: 80, height: 50)
                                }
                            }
                        }
                    }
                }.gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged { value in
                        //그냥 사각형만 그림
                        if isFirstSelectd == nil {
                            xStartIndex = xArray.lastIndex(where: {$0 < value.startLocation.x}) ?? 0
                            yStartIndex = yArray.lastIndex(where: {$0 < value.startLocation.y}) ?? 0
                            if let xStartIndex, let yStartIndex{
                                if mElement[xStartIndex][yStartIndex].isSelected == true {
                                    isFirstSelectd = true
                                } else {
                                    isFirstSelectd = false
                                }
                            }
                        }
                        startPoint = value.startLocation
                        endPoint = value.location
                    }
                    .onEnded { value in
                        //set 데이터를 변환하는 명령을 추가
                        xEndIndex = xArray.lastIndex(where: {$0 < value.location.x}) ?? 0
                        yEndIndex = yArray.lastIndex(where: {$0 < value.location.y}) ?? 0
                        if let xStartIndex = xStartIndex, let xEndIndex = xEndIndex, let yStartIndex = yStartIndex, let yEndIndex = yEndIndex{
                            for i in Array(stride(from: min(xStartIndex, xEndIndex),
                                                  to: max(xStartIndex, xEndIndex)+1,
                                                  by: 1)) {
                                for j in Array(stride(from: min(yStartIndex, yEndIndex),
                                                      to: max(yStartIndex, yEndIndex)+1,
                                                      by: 1)){
                                    if isFirstSelectd ?? false{
                                        mElement[i][j].isSelected = false
                                    } else {
                                        mElement[i][j].isSelected = true
                                    }
                                }
                            }
                        }
                        xEndIndex = nil
                        yEndIndex = nil
                        xStartIndex = nil
                        xEndIndex = nil
                        isFirstSelectd = nil
                        startPoint = nil
                        endPoint = nil
                    }
                )
//                Text("hakadl")
            }
        }
    }
}

struct TimeTableTestView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableTestView()
    }
}
