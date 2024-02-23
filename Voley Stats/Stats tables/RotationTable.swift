import SwiftUI

struct RotationTable: View {
    let labels: [String] = ["rotation".trad(),"side.out".trad(), "break.point".trad()]
    let match: Match
    let rotations: [((Int, Int),(Int, Int))]
    init(match: Match){
        self.match = match
        rotations = match.rotationStatsByNumber()
    }
    
    var body: some View {
        HStack {
//            HStack {
////                ForEach(labels, id: \.self){label in
////                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
////                }
//                Text("rotation".trad()).bold().frame(maxWidth: .infinity, alignment: .leading)
//                Text("side.out".trad()).bold().frame(width: 100)
//                Text("break.point".trad()).bold().frame(width: 100)
//            }.padding(3)
            VStack{
                ForEach([0,1,2], id:\.self){i in
                    //                let rotation = rotations[i]
                    HStack{
                        //                    Court(rotation: rotation.get(rotate: 0))
                        VStack{
                            Text("rotation".trad()).font(.title2).frame(maxWidth: .infinity)
                            Text("\(i+1)").font(.system(size: 40)).frame(maxHeight: .infinity)
                        }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            VStack{
                                Text("side.out".trad()).font(.subheadline).frame(maxWidth: .infinity)
                                HStack(spacing: 20){
                                    Text("+ \(rotations[i].0.0)").foregroundStyle(.green)
                                    Text("- \(rotations[i].0.1)").foregroundStyle(.red)
                                }
                                
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxHeight: .infinity)
                            VStack{
                                Text("break.point".trad()).font(.subheadline).frame(maxWidth: .infinity)
                                HStack(spacing: 20){
                                    Text("+ \(rotations[i].1.0)").foregroundStyle(.green)
                                    Text("- \(rotations[i].1.1)").foregroundStyle(.red)
                                }
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxHeight: .infinity)
                        }
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).foregroundColor(.white)
                }
            }
            VStack{
                ForEach([3,4,5], id:\.self){i in
                    //                let rotation = rotations[i]
                    VStack{
                        //                    Court(rotation: rotation.get(rotate: 0))
//                        HStack{
//                            Image(systemName: "plus.magnifyingglass").frame(maxWidth: .infinity, alignment: .trailing)//.font(.title2)
//                        }//.padding()
                        HStack{
                            VStack{
                                Text("rotation".trad()).font(.title2).frame(maxWidth: .infinity)
                                Text("\(i+1)").font(.system(size: 40)).frame(maxHeight: .infinity)
                            }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 15))
                            VStack{
                                VStack{
                                    Text("side.out".trad()).font(.subheadline).frame(maxWidth: .infinity)
                                    HStack(spacing: 20){
                                        Text("+ \(rotations[i].0.0)").foregroundStyle(.green)
                                        Text("- \(rotations[i].0.1)").foregroundStyle(.red)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxHeight: .infinity)
                                VStack{
                                    Text("break.point".trad()).font(.subheadline).frame(maxWidth: .infinity)
                                    HStack(spacing: 20){
                                        Text("+ \(rotations[i].1.0)").foregroundStyle(.green)
                                        Text("- \(rotations[i].1.1)").foregroundStyle(.red)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxHeight: .infinity)
                            }
                        }
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).foregroundColor(.white)
                }
            }
        }
        
    }
}
