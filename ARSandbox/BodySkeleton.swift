//
//  BodySkeleton.swift
//  ARSandbox
//
//  Created by Soham Ghugare on 28/09/23.
//

import Foundation
import RealityKit
import ARKit

class BodySkeleton: Entity {
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
    }
    
    @MainActor required init() {
        fatalError("init() has not been implemented")
    }
    
    // Helper function to create a new joint sphere
    private func createJoint(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}
