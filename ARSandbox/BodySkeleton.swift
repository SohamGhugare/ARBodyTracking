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
    
    // Helper function to create a skeleton bone
    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointFromName)),
              let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName))
        
        else { return nil }
        
        // Getting the root joint position (i.e. hipjoint)
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        // Getting the offset of joints from the root joint
        let jointFromEntityOffsetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3)
        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3)
        
        // Converting the positions from root reference, relative to world reference
        let jointFromEntityPosition = jointFromEntityOffsetFromRoot + rootPosition
        let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition
        
        // Creating joints and the bone connecting those joints
        let fromJoint = SkeletonJoint(name: bone.jointFromName, position: jointFromEntityPosition)
        let toJoint = SkeletonJoint(name: bone.jointToName, position: jointToEntityPosition)
        
        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }
    
    // Helper function to create a bone entity
    private func createBoneEntity(for skeletonBone: SkeletonBone, diameter: Float = 0.04, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, skeletonBone.length], cornerRadius: diameter/2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}
