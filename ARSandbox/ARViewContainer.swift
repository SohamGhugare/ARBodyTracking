//
//  ARViewContainer.swift
//  ARSandbox
//
//  Created by Soham Ghugare on 28/09/23.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)

        return arView

    }

    func updateUIView(_ uiView: ARView, context: Context) {}

}
