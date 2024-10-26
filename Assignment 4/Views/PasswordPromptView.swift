import SwiftUI

struct PasswordPromptView: View {
    @ObservedObject var passwordManager = PasswordManager()
    @State private var enteredPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                Text("Enter Your Password")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                
                SecureField("Password", text: $enteredPassword)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
                    .shadow(radius: 5)
                    .accessibilityIdentifier("Password")
                
                Button(action: authenticate) {
                    Text("Unlock")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .disabled(enteredPassword.isEmpty)
                .opacity(enteredPassword.isEmpty ? 0.5 : 1.0)
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func authenticate() {
        if passwordManager.validatePassword(enteredPassword) {
            isAuthenticated = true
        } else {
            alertMessage = "Invalid password."
            showAlert = true
        }
    }
}

#Preview {
    PasswordPromptView(isAuthenticated: .constant(false))
}
