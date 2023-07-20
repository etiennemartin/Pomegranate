//
//  ContentView.swift
//  Pomegranate
//
//  Created by Etienne Martin on 2023-07-20.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        // Bypass the main layout to load a specific view directly. This is not recommended since it wouldn't scale
        // to larger application, but for simple demo purposes this is easy to read and understand.
        switch ProcessInfo.processInfo.environment["uitesting.launchScreen"] {
        case "CapitalView":
            CapitalView(capital: Capital.all.first!)
        default:
            CapitalTableView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

