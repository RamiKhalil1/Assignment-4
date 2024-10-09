//
//  Assignment_4App.swift
//  Assignment 4
//
//  Created by Rami Khalil on 9/10/2024.
//

import SwiftUI

@main
struct Assignment_4App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
