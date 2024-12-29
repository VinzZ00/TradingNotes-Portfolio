//
//  TradingNotesApp.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 01/09/24.
//

import SwiftUI
import CoreData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TradingNotesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var navigationPath : NavigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                Home(navigationPath : $navigationPath)
            }
        }
    }
}
