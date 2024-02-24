import SwiftUI

struct SummaryTable: View {
    let data: Dictionary<String, Dictionary<String, Int>>
    var body: some View {
        VStack {
            HStack{
                VStack{
                    Text("\(data["header"]!["changes"]!)").font(.system(size: 40))
                    Text("n.changes".trad()).font(.title2)
                }.padding().frame(maxWidth: .infinity)
                VStack{
                    Text("server".trad()).font(.title2)
                    Text("\(data["header"]!["serving"]! == 0 ? "their.player".trad() : Player.find(id: data["header"]!["serving"]!)!.name)").font(.title)
                        .padding().background(data["header"]!["serving"]! == 0 ? .pink : .blue).clipShape(RoundedRectangle(cornerRadius: 8))
                }.padding().frame(maxWidth: .infinity)
                VStack{
                    Text("\(data["header"]!["score_us"]!)-\(data["header"]!["score_them"]!)").font(.system(size: 40))
                    Text("score".trad()).font(.title2)
                }.padding().frame(maxWidth: .infinity)
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().frame(maxWidth: .infinity)
            HStack{
                Text("coming.soon".trad()).frame(height: 200).frame(maxWidth: .infinity)
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
            HStack{
                VStack{
                    Text("serve".trad().uppercased()).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        VStack{
                            Text("\(data["serve"]!["total"]!)").font(.title)
                            Text("total".trad())
                        }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 15)).frame(minWidth: 90)
                        VStack{
                            Text("\(data["serve"]!["error"]!)").font(.title)
                            Text("errors".trad())
                        }.padding().background(.red).clipShape(RoundedRectangle(cornerRadius: 15)).frame(minWidth: 90)
                        VStack{
                            Text(".\(data["serve"]!["mark"]!)").font(.title)
                            Text("mark".trad())
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(minWidth: 90)
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
                VStack{
                    Text("receive".trad().uppercased()).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        VStack{
                            Text("\(data["receive"]!["total"]!)").font(.title)
                            Text("total".trad())
                        }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 15)).frame(minWidth: 90)
                        VStack{
                            Text("\(data["receive"]!["error"]!)").font(.title)
                            Text("errors".trad())
                        }.padding().background(.red).clipShape(RoundedRectangle(cornerRadius: 15)).frame(minWidth: 90)
                        VStack{
                            Text(".\(data["receive"]!["mark"]!)").font(.title)
                            Text("mark".trad())
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(minWidth: 90)
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
            }
            HStack{
                VStack{
                    Text("attack".trad().uppercased()).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        VStack{
                            Text("\(data["attack"]!["total"]!)").font(.title)
                            Text("total".trad())
                        }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            Text("\(data["attack"]!["kills"]!)").font(.title)
                            Text("kills".trad())
                        }.padding().background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            Text("\(data["attack"]!["error"]!)").font(.title)
                            Text("errors".trad())
                        }.padding().background(.red).clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
                VStack{
                    Text("block".trad().uppercased()).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        VStack{
                            Text("\(data["block"]!["total"]!)").font(.title)
                            Text("total".trad())
                        }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            Text("\(data["block"]!["blocks"]!)").font(.title)
                            Text("blocks".trad())
                        }.padding().background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            Text("\(data["block"]!["error"]!)").font(.title)
                            Text("errors".trad())
                        }.padding().background(.red).clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
            }
        }
    }
}
