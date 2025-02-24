//
//  StarsBGView.swift
//  SSC_2025
//
//  Created by Venkatesh Devendran on 22/2/25.
//

import SpriteKit
import SwiftUI


class BGScene: SKScene {
    
    var BGEmitter = SKEmitterNode(fileNamed: "BGPattern")!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black

        BGEmitter.position = CGPoint(x: frame.size.width, y: frame.size.height/2)
        BGEmitter.zPosition = -1
        addChild(BGEmitter)
    }
}
