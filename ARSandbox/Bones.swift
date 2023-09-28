//
//  Bones.swift
//  ARSandbox
//
//  Created by Soham Ghugare on 28/09/23.
//

import Foundation

enum Bones: CaseIterable {
    // Left arm
    case leftShoulderToLeftArm
    case leftArmToLeftForearm
    case leftForearmToLeftHand
    
    // Right arm
    case rightShoulderToLeftArm
    case rightArmToLeftForearm
    case rightForearmToLeftHand
    
    var name: String {
        return "\(self.jointFromName)-\(self.jointToName)"
    }
    
    var jointFromName: String {
        switch self {
        case .leftShoulderToLeftArm:
            return "left_shoulder_1_joint"
        case .leftArmToLeftForearm:
            return "left_arm_joint"
        case .leftForearmToLeftHand:
            return "left_forearm_joint"
            
        case .rightShoulderToLeftArm:
            return "right_shoulder_1_joint"
        case .rightArmToLeftForearm:
            return "right_arm_joint"
        case .rightForearmToLeftHand:
            return "right_forearm_joint"
        }
    }
    
    var jointToName: String {
        switch self {
        case .leftShoulderToLeftArm:
            return "left_arm_joint"
        case .leftArmToLeftForearm:
            return "left_forearm_joint"
        case .leftForearmToLeftHand:
            return "left_hand_joint"
            
        case .rightShoulderToLeftArm:
            return "right_arm_joint"
        case .rightArmToLeftForearm:
            return "right_forearm_joint"
        case .rightForearmToLeftHand:
            return "right_hand_joint"
        }
    }
}
