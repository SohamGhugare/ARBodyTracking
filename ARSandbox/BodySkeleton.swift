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
    var joints: [String: Entity] = [:]
    var bones: [String: Entity] = [:]
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.05
            var jointColor: UIColor = .cyan
            
            // Setting color and size based on specific jointName
            // Cyan => tracked by ARKit, Yellow => Follow the motion of closest cyan parent
            switch jointName {
            case "left_shoulder_1_joint", "right_shoulder_1_joint":
                jointRadius *= 0.5
            case "left_hand_joint", "right_hand_joint":
                jointRadius *= 1
                jointColor = .cyan
            case _ where jointName.hasPrefix("left_hand") || jointName.hasPrefix("right_hand"):
                jointRadius *= 0.25
                jointColor = .yellow
            default:
                jointRadius = 0.05
                jointColor = .cyan
            }
            
            // Creating an entity for this joint
            let jointEntity = createJoint(radius: jointRadius, color: jointColor)
            
            // Adding to joints directory
            joints[jointName] = jointEntity
            
            // Added to parent entity
            self.addChild(jointEntity)
        }
        
        for bone in Bones.allCases {
            guard let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor)
            else { continue }
            
            // Creating an entity for the bone
            let boneEntity = createBoneEntity(for: skeletonBone)
            bones[bone.name] = boneEntity
            self.addChild(boneEntity)
        }
    }
    
    @MainActor required init() {
        fatalError("init() has not been implemented")
    }
    
    // Updating the joints and bones with new AR Session data
    func update(with bodyAnchor: ARBodyAnchor){
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        // Updating joints
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName],
               let jointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                // Position relative to root
                let jointEntityOffsetFromRoot = simd_make_float3(jointEntityTransform.columns.3)
                
                // Position relative to world
                jointEntity.position = jointEntityOffsetFromRoot + rootPosition
                jointEntity.orientation = Transform(matrix: jointEntityTransform).rotation
            }
        }
        
        // Updating bones
        for bone in Bones.allCases {
            let boneName = bone.name
            
            guard let entity = bones[boneName],
                  let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor)
            else { continue }
            
            // Setting position for bone
            entity.position = skeletonBone.centerPosition
            
            // Setting orientation for bone
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil)
        }
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
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}
