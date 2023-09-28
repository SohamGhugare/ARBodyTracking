//
//  ContentView.swift
//  ARSandbox
//
//  Created by Soham Ghugare on 28/09/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
//        ARViewContainer().edgesIgnoringSafeArea(.all)
        VStack {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.blue)
                .padding(.bottom, 20)
            Text("Hello World")
        }
    }
}


#Preview {
    ContentView()
}
