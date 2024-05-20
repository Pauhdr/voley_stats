//
//  Voley_StatsApp.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 15/4/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct Voley_StatsApp: App {
//    private let pilot: UIPilot<AppRoute>
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @StateObject var user: User?
    init() {
        let navBarAppearance = UINavigationBar.appearance()
    
//                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        pilot = .init(initial: .ListTeam)
        CustomFonts.registerFonts()
//        user = Auth.auth().currentUser
//        if user = user {
//            let id = user.uid
//            let email = user.email
//        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
    }
}
