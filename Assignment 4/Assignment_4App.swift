import SwiftUI

@main
struct Assignment_4App: App {
    let persistenceController = PersistenceController.shared
    @State private var isAuthenticated = false
    @ObservedObject var passwordManager = PasswordManager()

    var body: some Scene {
        WindowGroup {
            if passwordManager.isPasswordSet && !isAuthenticated {
                PasswordPromptView(isAuthenticated: $isAuthenticated)
            } else {
                WelcomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
