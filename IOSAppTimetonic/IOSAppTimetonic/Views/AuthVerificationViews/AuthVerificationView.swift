//
//  AuthVerificationView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 29/01/24.
//

import SwiftUI

struct AuthVerificationView: View {
    
    @StateObject var authVerificationViewModel = AuthVerificationViewModel.shared
    
    var body: some View { 
        var subtitle: String {authVerificationViewModel.authenticationStatusMessage}
        var authProcess: Bool {authVerificationViewModel.isAuthenticating}
        var colorProgress: Int {authVerificationViewModel.authenticationIndicator}
        var messageError: String {authVerificationViewModel.latestErrorMessage}
        
        VStack{
            Spacer()
            Text("Authentication")
                .font(.largeTitle)
                .padding(5)
            
            Text(subtitle)
                .font(.title)
            
            Spacer()
            
            if authProcess{
                ProgressView()
                    .scaleEffect(x:4, y:4, anchor: .center)
                    .padding()
                    .tint(.green.opacity(Double(colorProgress + 1) * 0.33))
            } else {
                Image(systemName: messageError != "" ? "x.circle" : "checkmark.circle" )
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(messageError != "" ? .red : .green )
            }
            
            Spacer()
            
            Text(messageError == "" ? "Verified" : "Error: ")
                .font(.largeTitle)
                .padding()
            
            Text(messageError)
                .font(.title)
                .padding()
           
            Spacer()
        }
        .background(
            NavigationLink("", destination: LandingPageView(), isActive: $authVerificationViewModel.isAuthenticationComplete)
        )
    }
}
    

#Preview {
    AuthVerificationView()
}
