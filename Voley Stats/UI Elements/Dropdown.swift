//
//  Dropdown.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 24/5/24.
//

import SwiftUI

struct Dropdown<T:Model>: View {
    @Binding var selection: [T]
    var options: [T]
    @State var open: Bool = false
    init(selection: Binding<[T]>, options: [T]) {
        self._selection = selection
        self.options = options
    }
    var body: some View {
        GeometryReader{ _ in
            VStack{
                HStack{
                    Text("Select value")
                    Image(systemName: open ? "chevron.up" : "chevron.down").frame(maxWidth: .infinity, alignment: .trailing)
                        .onTapGesture {
                            withAnimation(.snappy){
                                open.toggle()
                            }
                        }
                }.padding().frame(maxWidth: .infinity).background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                    .overlay(open ?
                if open{
                    ScrollView{
                        VStack{
                            ForEach(options, id: \.id){ option in
                                HStack{
                                    if self.selection.contains(option){
                                        Image(systemName: "checkmark")
                                    }
                                    Text(option.description)
                                }.padding().frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        if self.selection.contains(option){
                                            self.selection = self.selection.filter{$0 != option}
                                        }else{
                                            self.selection.append(option)
                                        }
                                    }
                            }
                        }.padding().frame(maxWidth: .infinity, maxHeight: 300)
                    }
                        .background(.black).clipShape(RoundedRectangle(cornerRadius: 8))
//                        .offset(CGSize(width: 0, height: 105))
                }
//                             : nil)
            }
        }.frame(maxWidth: 300).frame(height: 100).foregroundStyle(.white).zIndex(10).ignoresSafeArea()//.background(.red)
    }
}

//#Preview {
//    @State var sel:[Team] = []
//    VStack{
//        Dropdown(selection: $sel, options: Team.all())
//    }.background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//}
