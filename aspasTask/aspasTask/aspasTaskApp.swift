//
//  aspasTaskApp.swift
//  aspasTask
//
//  Created by Pavan manikanta on 18/05/23.
//

import SwiftUI

@main
struct aspasTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
