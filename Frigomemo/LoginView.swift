//
//  LoginView.swift
//  Frigomemo
//
//  Created by Yihan Wang on 11/8/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // App Icon/Title
                VStack(spacing: 16) {
                    Image(systemName: "refrigerator.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    Text("Frigomemo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Track your food expiration dates")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Login Form
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
                    
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Button(action: signIn) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(authManager.isLoading ? "Signing in..." : "Sign In")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                    
                    Button(action: { showingSignUp = true }) {
                        Text("Don't have an account? Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .sheet(isPresented: $showingSignUp) {
                SignUpView(authManager: authManager)
            }
        }
    }
    
    private func signIn() {
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
            } catch {
                // Error is handled by authManager
            }
        }
    }
}

#Preview {
    LoginView(authManager: AuthenticationManager())
}
