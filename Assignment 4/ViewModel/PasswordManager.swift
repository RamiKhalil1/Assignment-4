import Foundation

class PasswordManager: ObservableObject {
    @Published var isPasswordSet: Bool = false
    
    init() {
        loadPasswordStatus()
    }
    
    func setPassword(_ password: String) {
        UserDefaults.standard.set(password, forKey: "AppPassword")
        isPasswordSet = true
    }
    
    func validatePassword(_ password: String) -> Bool {
        guard let storedPassword = UserDefaults.standard.string(forKey: "AppPassword") else {
            return false
        }
        return password == storedPassword
    }
    
    func changePassword(currentPassword: String, newPassword: String) -> Bool {
        if validatePassword(currentPassword) {
            setPassword(newPassword)
            return true
        }
        return false
    }
    
    private func loadPasswordStatus() {
        if UserDefaults.standard.string(forKey: "AppPassword") != nil {
            isPasswordSet = true
        }
    }
    
    func removePassword() {
        UserDefaults.standard.removeObject(forKey: "AppPassword")
        isPasswordSet = false
    }
}

