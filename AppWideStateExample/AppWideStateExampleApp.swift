//
//  AppWideStateExampleApp.swift
//  AppWideStateExample
//
//  Created by TI Digital on 27/06/22.
//

import SwiftUI

@main
struct AppWideStateExampleApp: App {
    @StateObject var container: AppStateContainer = .shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.asRootView()
        }
    }
}
