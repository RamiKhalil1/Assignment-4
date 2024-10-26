import SwiftUI

struct PasswordSettingsView: View {
    @ObservedObject var passwordManager = PasswordManager()
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                if passwordManager.isPasswordSet {
                    Section(header: Text("Change Password")) {
                        SecureField("Current Password", text: $currentPassword)
                        SecureField("New Password", text: $newPassword)
                        SecureField("Confirm New Password", text: $confirmPassword)
                        
                        Button("Change Password") {
                            changePassword()
                        }
                        .disabled(newPassword.isEmpty || confirmPassword.isEmpty || currentPassword.isEmpty)
                    }
                    
                    Section(header: Text("Remove Password")) {
                        Button("Remove Password") {
                            passwordManager.removePassword()
                        }
                    }
                } else {
                    Section(header: Text("Set Password")) {
                        SecureField("New Password", text: $newPassword)
                            .accessibilityIdentifier("newPassword")
                        SecureField("Confirm New Password", text: $confirmPassword)
                            .accessibilityIdentifier("confirmPassword")
                        
                        Button("Set Password") {
                            setPassword()
                        }
                        .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                    }
                }
            }
            .navigationTitle("Password Settings")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func setPassword() {
        if newPassword == confirmPassword {
            passwordManager.setPassword(newPassword)
            alertMessage = "Password has been set successfully."
        } else {
            alertMessage = "Passwords do not match."
        }
        showAlert = true
    }
    
    private func changePassword() {
        if newPassword == confirmPassword {
            if passwordManager.changePassword(currentPassword: currentPassword, newPassword: newPassword) {
                alertMessage = "Password has been changed successfully."
            } else {
                alertMessage = "Current password is incorrect."
            }
        } else {
            alertMessage = "Passwords do not match."
        }
        showAlert = true
    }
}

#Preview {
    PasswordSettingsView()
}

