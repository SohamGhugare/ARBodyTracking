//
//  ARViewContainer.swift
//  ARSandbox
//
//  Created by Soham Ghugare on 28/09/23.
//

import SwiftUI
import ARKit
import RealityKit

private var bodySkeleton: BodySkeleton?
private let bodySkeletonAnchor = AnchorEntity()

struct ARViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        // Setting up the AR Scene
        arView.setupForBodyTracking()
        arView.scene.addAnchor(bodySkeletonAnchor)

        return arView

    }

    func updateUIView(_ uiView: ARView, context: Context) {}

}

extension ARView: ARSessionDelegate {
    func setupForBodyTracking() {
        // Setting configuration for body tracking
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
        
        // Setting session delegate
        self.session.delegate = self
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // Looping thru all anchors that are detected
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    // BodySkeleton already exists then update all joints and bones
                    skeleton.update(with: bodyAnchor)
                } else {
                    // Body is detected for first time. Create BodySkeleton and add it to anchor
                    bodySkeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeletonAnchor.addChild(bodySkeleton!)
                }
            }
        }
    }
}
