//
//  Teste_CalculadoraApp.swift
//  Teste-Calculadora
//
//  Created by Heitor Fernandes on 20/05/24.
//

import SwiftUI

@main
struct Teste_CalculadoraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            // Disable the default "New Window" command
            CommandGroup(replacing: CommandGroupPlacement.newItem) { }
        }
    }
    
    init() {
        configureWindow()
    }
    
    private func configureWindow() {
        if let window = NSApplication.shared.windows.first {
            window.setContentSize(NSSize(width: 400, height: 700))  // Set your desired window size
            window.minSize = NSSize(width: 400, height: 700)  // Set your desired minimum window size
            window.center()
        }
    }
}

