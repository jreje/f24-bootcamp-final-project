//
//  FlashcardView.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 11/19/24.
//

import SwiftUI

struct FlashcardView: View {
    @State private var isBack: Bool = false
    @State private var rotation: Double = 0
    let flashcard: Flashcard
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 25)
                    .overlay(alignment: .center) {
                        ZStack {
                            if !isBack {
                                Text(flashcard.question)
                                    .foregroundStyle(.black)
                            } else {
                                Text(flashcard.answer)
                                    .foregroundStyle(.black)
                                    .rotation3DEffect(
                                    .degrees(180),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                    )
                            }
                        }
                        .padding()
                    }
                    .bold()
                    .foregroundStyle(.white)
                        
                }
                .rotation3DEffect(
                        .degrees(rotation),
                        axis: (x: 0.0, y: -1.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0,
                        perspective: 0.3
                )
                    
            }
            .onTapGesture {
                withAnimation(.bouncy(duration: 0.5)) {
                    isBack.toggle()
                    rotation += 180
                }
            }
        }
}

#Preview {
    FlashcardView(flashcard: .example)
}
