//
//  RootMapApp.swift
//  RootMap
//
//  Created by Macbook on 3/25/22.
//

import SwiftUI

@main
struct RootMapApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
