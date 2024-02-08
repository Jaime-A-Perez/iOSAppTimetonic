//
//  ContentView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVerificationViewModel : AuthVerificationViewModel
    
    var body: some View {
        switch authVerificationViewModel.authenticationState {
        case .checkingIfAlreadyAuthenticated:
            ProgressView("Checking authentication...")
                .scaleEffect(x:1.6, y:1.6, anchor: .center)
                .tint(.blue)
            if authVerificationViewModel.latestErrorMessage != "" {
                Text(authVerificationViewModel.latestErrorMessage)
            }
        case .idle:
            NavigationView{ LoginView() }
        case .authenticated:
            LandingPageView()
        default:
            NavigationView{ LoginView() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthVerificationViewModel.shared)
    }
}
