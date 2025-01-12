//
//  DeckView.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 11/24/24.
//

import SwiftUI

struct DeckView: View {
    var deck: Deck
    
    @State private var isStudying = false
    
    @ViewBuilder
    func studyView() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isStudying.toggle()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding()
            
            Spacer()
            
            TabView {
                ForEach(deck.cards) { card in
                    FlashcardView(flashcard: card)
                        .frame(height: 500)
                        .padding()
                }
            }
            
            Spacer()
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(Color(uiColor: .systemGray6))

    }
    var body: some View {
            NavigationView {
                VStack {
                    Text(deck.name)
                        .font(.largeTitle)
                        .padding()

                    Button("Study Cards") {
                        isStudying.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Spacer()
                }
                .sheet(isPresented: $isStudying) {
                    studyView()
                }
            }
        }
}

#Preview {
    DeckView(deck: .example)
}
