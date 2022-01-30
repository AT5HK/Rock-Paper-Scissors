//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by auston salvana on 1/29/22.
//

import SwiftUI

struct BGColor: ViewModifier {
    let buttonText: String
    
    func body(content: Content) -> some View {
        if buttonText == Moves.rock.uppercaseString {
            content
                .background(.green)
        } else if buttonText == Moves.paper.uppercaseString {
            content
                .background(.red)
        } else if buttonText == Moves.scissors.uppercaseString {
            content
                .background(.yellow)
        }
    }
}


struct BigButton: View {
    let text: String
    let completionMethod: () -> Void
    
    
    var body: some View {
        Button(text) {
            completionMethod()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .font(.largeTitle.bold())
        .foregroundColor(.white)
        .modifier(BGColor(buttonText: text))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

enum Moves: String, CaseIterable {
    case rock
    case paper
    case scissors
    
    var uppercaseString: String {
        return self.rawValue.uppercased()
    }
    
    static func emojiView(move currentMove: Self) -> some View {
       
        switch currentMove {
        case .rock:
            return Text("👊").font(.system(size: 100))
        case .paper:
            return Text("🖐").font(.system(size: 100))
        case .scissors:
            return Text("✌️").font(.system(size: 100))
        }
    }
}

extension Bool {
    var toString: String {
        return self ? "WIN" : "LOSE"
    }
}



struct ContentView: View {
    let moves: Array<Moves> = [.rock, .paper, .scissors]
    let winningMoves: Array<Moves> = [.paper, .scissors, .rock]
    let losingMoves: Array<Moves> = [.scissors, .rock, .paper]
    
    
    private var scoreTitle: String {
        return "You have \(userPointsCounter) points"
    }
    
    @State private var isShowing = false
    
    @State private var userMove = Moves.rock
    @State private var computerMove = Int.random(in: 0..<3)
    @State private var computerShouldWin = Bool.random()
    @State private var userPointsCounter = 0
    @State private var alertMessage = ""

    func nextRound() {
        computerMove = Int.random(in: 0..<3)
        computerShouldWin = Bool.random()
    }
    
    func buttonTapped() {
        let computerSelection = computerMove
        var userSelection = 0
        
        if computerShouldWin {
            userSelection = losingMoves.firstIndex(of: userMove)!
        } else {
            userSelection = winningMoves.firstIndex(of: userMove)!
        }
        
        
        if (computerSelection == userSelection) {
            userPointsCounter += 1
            alertMessage = "You are correct"
        } else {
            alertMessage = "You are wrong"
        }
        
    }
    
    var body: some View {
        Spacer()
        VStack {
            Text("\(moves[computerMove].uppercaseString) " + "\(computerShouldWin.toString)S AGAINST")
                .multilineTextAlignment(.center)
                .padding()
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Moves.emojiView(move: moves[computerMove])
            Spacer()
            VStack(spacing: 20) {
                ForEach(moves, id: \.self) { move in
                    BigButton(text: move.uppercaseString) {
                        userMove = move
                        buttonTapped()
                        isShowing = true
                        print(move.uppercaseString)
                    }
                }
                .alert(scoreTitle, isPresented: $isShowing) {
                    Button("Ok", action: nextRound)
                } message: {
                    Text(alertMessage)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
