//
//  PricingCard.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 16/5/24.
//

import SwiftUI

struct PricingCard: View {
    var name: String
    var color: Color
    var advantages: [String]
    var width: CGFloat = 300
    var height: CGFloat = 500
    var body: some View {
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius: 15)
                
//                    .fill(Color.swatch.dark.high)
                .stroke(color, lineWidth: 15)
                .background(Color.swatch.dark.high)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: width, height: height)
            RoundedRectangle(cornerRadius: 15).fill(color).frame(width: width, height: height/3)
            ZStack{
                Circle().fill(Color.swatch.dark.high)
                Text("1.99").foregroundStyle(color).font(.largeTitle).fontWeight(.bold)
            }.frame(width: width/2).padding(.top, height/4)
            VStack{
                VStack{
                    Image(systemName: "person.circle.fill").font(.custom("", size: 64))
                    Text(name)//.font(.title)
                }.padding().frame(height: height/3, alignment: .top)
                VStack{
                    ForEach(advantages, id: \.self){adv in
                        Text(adv).foregroundStyle(.white)
                    }
                }.frame(height: (height/3)*2, alignment: .center)
//                Spacer()
            }//.padding(.bottom).frame(height: height, alignment: .top)
        }
    }
}

#Preview {
    PricingCard(name: "Test", color: .yellow, advantages: ["advantage 1", "Advantage 2"])
}
