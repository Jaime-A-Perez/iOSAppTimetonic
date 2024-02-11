//
//  ContentView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVerificationViewModel : AuthVerificationViewModel
    @State var changeView = false
    
    var body: some View {
        NavigationView{ 
            switch authVerificationViewModel.authenticationState {
            case .checkingIfAlreadyAuthenticated:
                VStack{
                    ProgressView("Checking authentication...")
                        .scaleEffect(x:1.6, y:1.6, anchor: .center)
                        .tint(.blue)
                        .padding(.vertical, 310)
                    if authVerificationViewModel.latestErrorMessage != "" {
                        Text(authVerificationViewModel.keyManagementError)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            case .idle:
                LoginView()
            case .authenticated:
                LandingPageView()
            default:
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthVerificationViewModel.shared)
    }
}
