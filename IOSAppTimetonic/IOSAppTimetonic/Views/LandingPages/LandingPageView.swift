//
//  LandingPageView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 7/02/24.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject private var landingPageViewModel = LandingPageViewModel(networkService: NetworkService())
    @StateObject private var authVerificationViewModel = AuthVerificationViewModel.shared
    @State private var isActiveOptions: Bool = false
    @State private var logInActive: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            header
                .alert(isPresented: $isActiveOptions, content: {
                    Alert(
                        title: Text("Log out"),
                        message: Text("\(Constants.API.userEmail)\nAre you sure you want log out?"),
                        primaryButton: .cancel(),
                        secondaryButton: .destructive(Text("Yes"), action: {
                            logInActive = true
                            authVerificationViewModel.sessKeyDelete()
                        }))
                })
                .background(
                    NavigationLink("", destination: LoginView(), isActive: $logInActive))
            
            listView
                .cornerRadius(30)
                .padding(.horizontal, 5)
                .shadow(radius: 3)
        }
        .onAppear {
            landingPageViewModel.loadBooks()
        }
    }
    
    private var header: some View {
        HStack{
            Text("All Books")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {isActiveOptions = true}, label: {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26)
                    .foregroundColor(.secondary)
            })
        }
        .padding(.horizontal, 24)
    }
    
    private var listView: some View {
        List(landingPageViewModel.books.indices, id: \.self) { index in
            bookRow(for: index)
                .padding(.vertical, 5)
        }
        .listRowSpacing(5)
    }
    
    @ViewBuilder
    private func bookRow(for index: Int) -> some View {
        let book = landingPageViewModel.books[index]
        HStack {
            bookImage(for: book)
            bookDetails(for: book)
        }
        .foregroundColor(.blue)
    }
    
    @ViewBuilder
    private func bookImage(for book: Book) -> some View {
        if let coverImageURLString = book.ownerPreferences?.coverImage, let coverImageUrl = URL(string: "\(Constants.API.baseUrlImage)\(coverImageURLString)") {
            AsyncImage(url: coverImageUrl)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .shadow(radius: 6, x: -2, y: 2)
        } else {
            Image(systemName: "book.fill")
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .shadow(radius: 6, x: -2, y: 2)
        }
    }
    
    @ViewBuilder
    private func bookDetails(for book: Book) -> some View {
        let nameBook = book.form?.name
        let fragments = nameBook?.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true).map(String.init)
        VStack(alignment: .leading, spacing: 5) {
            Text(fragments?[0].capitalized ?? "Title")
                .font(.headline)
                .foregroundColor(.primary)
            Text(fragments?[1].capitalized ?? "Subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
        .padding(.leading, 6)
    }
}

#Preview {
    LandingPageView()
}
