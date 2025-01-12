//
//  Home.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 11/19/24.
//

import SwiftUI

// make it look prettier
struct Home: View {
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("Mabuhay!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Ready to start learning?")
                .font(.subheadline)
            
            Spacer()
            

            NavigationLink {
                DeckView(deck: .example)
            } label: {
                Text("Flashcards")
            }
                .frame(maxWidth: 200, maxHeight: 50)
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .cornerRadius(20)
            
            NavigationLink {
                DictionaryView()
            } label: {
                Text("Dictionary")
            }
                .frame(maxWidth: 200, maxHeight: 50)
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .cornerRadius(20)
            
            Spacer()
        }
    }
}

#Preview {
    Home()
}
