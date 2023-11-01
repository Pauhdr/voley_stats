//
//  Voley_StatsApp.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 15/4/23.
//

import SwiftUI
import UIPilot
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Voley_StatsApp: App {
    private let pilot: UIPilot<AppRoute>
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var network = NetworkMonitor()
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        pilot = .init(initial: .ListTeam)
        CustomFonts.registerFonts()
    }
    var body: some Scene {
        WindowGroup {
            UIPilotHost(pilot){route in
                switch route {
                case .ListTeam:
                    AnyView(ListTeams(viewModel:ListTeamsModel(pilot: pilot)))
                case .InsertTeam(let team):
                    AnyView(TeamData(viewModel:TeamDataModel(pilot: pilot, team: team)))
                case .ExerciseView(let team, let exercise):
                    AnyView(ExerciseView(viewModel:ExerciseViewModel(pilot: pilot, team: team, exercise: exercise)))
                case .InsertMatch(let team, let match):
                    AnyView(MatchData(viewModel:MatchDataModel(pilot: pilot, team: team, match: match)))
//                case .SetupSet(let team, let match, let set):
//                    AnyView(SetData(viewModel:SetDataModel(pilot: pilot, team: team, match: match, set: set), rootActive: false))
//                case .CaptureStats(let team, let match, let set):
//                    AnyView(StatsView(viewModel:StatsViewModel(pilot: pilot, team: team, match: match, set: set)))
                case .MatchStats(let team, let match):
                    AnyView(MatchStats(viewModel:MatchStatsModel(team: team, match: match)))
                case .TrainStats(let team):
                    AnyView(TrainStats(viewModel: TrainStatsModel(pilot: pilot, team: team)))
                case .ShowQn(let team):
                    AnyView(ListQN(viewModel: ListQNModel(pilot: pilot, team: team)))
                case .InsertPlayer(let team, let player):
                    AnyView(PlayerData(viewModel:PlayerDataModel(team: team, player: player)))
                case .InsertExercise(let exercise):
                    AnyView(ExerciseData(viewModel:ExerciseDataModel(pilot: pilot, exercise: exercise)))
                case .NewScouting(let team, let scout):
                    AnyView(ScoutData(viewModel: ScoutDataModel(pilot: pilot, team: team, scout: scout)))
                case .Scouting(let team, let scout):
                    AnyView(Scouting(viewModel: ScoutingModel(pilot: pilot, team: team, scout: scout)))
//                    case .AreaImproves(let team, let area, let actions):
//                        AnyView(AreaImproves(viewModel: AreaImprovesModel(pilot: pilot, team: team, area: area, actions: actions)))
                }
            
            }.environmentObject(network)
//            ListTeams(viewModel: ListTeamsModel(pilot: pilot))
        }
    }
}

enum AppRoute: Equatable {
    
    case ListTeam
    case InsertTeam(team: Team?)
    case TrainStats(team: Team)
    case ShowQn(team: Team)
//    case AreaImproves(team: Team, area:String, actions:[(Player, Action)])
    case ExerciseView(team: Team, exercise:Exercise)
    case InsertExercise(exercise: Exercise?)
    case InsertMatch(team: Team, match: Match?)
    case NewScouting(team: Team, scout:Scout?)
    case Scouting(team: Team, scout:Scout)
//    case SetupSet(team: Team, match: Match, set: Set)
//    case CaptureStats(team:Team, match: Match, set: Set)
    case MatchStats(team:Team, match: Match)
    case InsertPlayer(team: Team?, player: Player?)
}
