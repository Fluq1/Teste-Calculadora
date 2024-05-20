//
//  ContentView.swift
//  Teste-Calculadora
//
//  Created by Heitor Fernandes on 20/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var display: String = "0"
    @State private var firstOperand: Double? = nil
    @State private var secondOperand: Double? = nil
    @State private var currentOperation: String? = nil

    @State private var buttonStates: [String: Bool] = [:] // Dictionary to track button states

    let buttons: [[String]] = [
        ["C", "÷", "×"],
        ["7", "8", "9", "−"],
        ["4", "5", "6", "+"],
        ["1", "2", "3", "="],
        ["0", "."]
    ]
    
    var body: some View {
        ZStack {
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow, state: .active)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        if let operation = currentOperation, let firstOperand = firstOperand {
                            Text("\(firstOperand.clean) \(operation)")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.7))
                                .transition(.opacity)
                        }
                        Text(display)
                            .font(.system(size: 64))
                            .foregroundColor(.white)
                            .padding()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .transition(.opacity)
                            .id(display) // Ensure unique identifier for proper animation
                    }
                }
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
                
                VStack(spacing: 10) {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { button in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.buttonTapped(button)
                                        self.buttonStates[button] = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            self.buttonStates[button] = false
                                        }
                                    }
                                }) {
                                    Text(button)
                                        .font(.system(size: 32))
                                        .frame(width: self.buttonWidth(button), height: self.buttonHeight())
                                        .background(self.buttonColor(button))
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                        .scaleEffect(self.buttonStates[button] == true ? 1.1 : 1.0)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
    }
    
    func buttonTapped(_ button: String) {
        switch button {
        case "0"..."9", ".":
            numberTapped(button)
        case "÷", "×", "−", "+":
            operationTapped(button)
        case "=":
            calculateResult()
        case "C":
            clear()
        default:
            break
        }
    }
    
    func numberTapped(_ number: String) {
        if display == "0" || (currentOperation != nil && secondOperand == nil) {
            display = number
        } else {
            display += number
        }
        if currentOperation == nil {
            firstOperand = Double(display)
        } else {
            secondOperand = Double(display)
        }
    }
    
    func operationTapped(_ operation: String) {
        currentOperation = operation
        secondOperand = nil
        display = "0"
    }
    
    func calculateResult() {
        guard let first = firstOperand, let second = secondOperand, let operation = currentOperation else { return }
        
        var result: Double?
        switch operation {
        case "÷":
            result = first / second
        case "×":
            result = first * second
        case "−":
            result = first - second
        case "+":
            result = first + second
        default:
            break
        }
        
        if let res = result {
            withAnimation(.easeInOut) {
                display = res.clean
            }
            firstOperand = res
            secondOperand = nil
            currentOperation = nil
        }
    }
    
    func clear() {
        withAnimation(.easeInOut) {
            display = "0"
            firstOperand = nil
            secondOperand = nil
            currentOperation = nil
        }
    }
    
    func buttonWidth(_ button: String) -> CGFloat {
        return button == "0" ? 170 : 80
    }
    
    func buttonHeight() -> CGFloat {
        return 80
    }
    
    func buttonColor(_ button: String) -> Color {
        switch button {
        case "÷", "×", "−", "+":
            return .orange
        case "=":
            return .green
        case "C":
            return .red
        default:
            return .gray
        }
    }
}

extension Double {
    var clean: String {
        return String(format: "%g", self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
