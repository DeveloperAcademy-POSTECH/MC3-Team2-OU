//
//  FixedTimeElementView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/27.
//

import SwiftUI

struct FixedTimeElementView: View {
    var fixedTimeModel : FixedTimeModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.whiteColor)
            VStack(alignment : .leading, spacing : 14){
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.primaryColor)
                        Text("\(fixedTimeModel.category)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }.frame(width: 44, height: 25)
                    ForEach(Array(fixedTimeModel.weekdays.enumerated()), id : \.1) { (index, element) in
                        let b : Int? = element.rawValue
                        Text("\(b.dayOfWeek())" +
                             ((fixedTimeModel.weekdays.count-1 == index) ? "" : ","))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primaryColor)
                    }
                }
                HStack(spacing: 70){
                    VStack(alignment: .leading){
                        HStack(spacing: 0){
                            Text("\(Image(systemName: "circle"))")
                                .font(.system(size:13, weight: .bold))
                                .foregroundColor(Color(hex: "A2A2A5"))
                            Text(" 시작 시간")
                                .font(.system(size:13, weight: .bold))
                                .foregroundColor(Color(hex: "A2A2A5"))
                        }
                        Text(DateUtil.getFormattedTime(fixedTimeModel.start))
                            .font(.system(size: 23, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            
                    }
                    VStack(alignment: .leading){
                        HStack(spacing: 0){
                            Text("\(Image(systemName: "circle.fill"))")
                                .font(.system(size:13, weight: .bold))
                                .foregroundColor(Color(hex: "A2A2A5"))
                            Text(" 종료 시간")
                                .font(.system(size:13, weight: .bold))
                                .body(textColor: Color(hex: "A2A2A5"))
                            
                        }
                        Text(DateUtil.getFormattedTime(fixedTimeModel.end))
                            .font(.system(size: 23, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                
            }.padding(EdgeInsets(top: 19, leading: 18, bottom: 18, trailing: 19))
         
        }.frame(width: 358, height: 121) 
    }
}

struct FixedTimeElementView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            FixedTimeElementView(fixedTimeModel : FixedTimeModel())
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.backgroundColor)
        VStack{
            FixedTimeElementView(fixedTimeModel : FixedTimeModel())
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.backgroundColor)
            .preferredColorScheme(.dark)
    }
}
