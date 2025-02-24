//
//  EndScene.swift
//  SSC_2025
//
//  Created by Venkatesh Devendran on 24/2/25.
//

import SwiftUI
import SpriteKit

class EndScene: SKScene {
    
    var ProximaCentauri = SKEmitterNode(fileNamed: "ProximaCentauri")!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black

        ProximaCentauri.position = CGPoint(x: frame.size.width, y: frame.size.height/2)
        ProximaCentauri.zPosition = -1
        addChild(ProximaCentauri)
        
    }
}
