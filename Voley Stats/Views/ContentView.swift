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
//    init(){
////        path.path.append(ListTeams(viewModel: ListTeamsModel()))
//    }
    var body: some View {
        if #available(iOS 16.0, *){
            NavigationStack(path: $path.path){
                ZStack(alignment: .bottomTrailing){
                    ListTeams(viewModel: ListTeamsModel())//.environmentObject(network)
                    
                }
            }.environmentObject(network).environmentObject(path)
        } else{
            NavigationView{
                ListTeams(viewModel: ListTeamsModel()).environmentObject(network)
            }.navigationViewStyle(StackNavigationViewStyle()).environmentObject(network)
                
        }
    }
}
