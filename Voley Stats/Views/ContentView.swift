//
//  ContentView.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 2/1/24.
//

import SwiftUI

struct ContentView:View{
    @StateObject var network = NetworkMonitor()
    @State var path = PathManager()
    @State var newSeason: Bool = UserDefaults.standard.string(forKey: "season") == nil
    @State var seasonName: String = "\("season".trad()) \(Date.now.formatted(.dateTime.year()))-\(Calendar.current.date(byAdding: .year, value: 1, to: Date.init())?.formatted(.dateTime.year()) ?? Date.now.formatted(.dateTime.year()))"
//    init(){
////        path.path.append(ListTeams(viewModel: ListTeamsModel()))
//    }
    var body: some View {
        if #available(iOS 16.0, *){
            NavigationStack(path: $path.path){
                ZStack(alignment: .center){
                    ListTeams(viewModel: ListTeamsModel())//.environmentObject(network)
                    if newSeason{
                        ZStack{
                            Rectangle().fill(.black.opacity(0.7)).ignoresSafeArea()
                            VStack{
                                Text("name.season".trad()).font(.title2)
                                VStack(alignment: .leading){
                                    //                Text("opponent".trad()).font(.caption)
                                    TextField("season".trad(), text: $seasonName).textFieldStyle(TextFieldDark())
                                }.padding(.bottom)
                                Text("save".trad()).padding().background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity).padding().onTapGesture {
                                    UserDefaults.standard.set(seasonName, forKey: "season")
                                    newSeason.toggle()
                                    //                                if Season.create(season: Season(name: seasonName)) != nil{
                                    //                                    newSeason.toggle()
                                    //                                }
                                }
                            }.padding()
                                .background(.black)
                                .foregroundStyle(.white)
                            //        .frame(width:500, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 25)).padding()
                        }
                    }
                }
            }.environmentObject(network).environmentObject(path)
        } else{
            NavigationView{
                ListTeams(viewModel: ListTeamsModel()).environmentObject(network)
            }.navigationViewStyle(StackNavigationViewStyle()).environmentObject(network)
                
        }
    }
}
