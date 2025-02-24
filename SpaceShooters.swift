//
//  SpaceShooters.swift
//  SSC_2025
//
//  Created by Venkatesh Devendran on 2/2/25.
//

import SpriteKit
import SwiftUI
import AVFoundation

enum MoveDirection {
    case front
    case left
    case right
}

struct PhysicsCategory{
    static let spaceship: UInt32 = 1
    static let laser: UInt32 = 2
    static let lootBox: UInt32 = 4
    static let jumpgate: UInt32 = 8
    static let shields: UInt32 = 16
    static let asteroid: UInt32 = 32
}

var GameOverTexts: [[String]] = [
    [
        "Good Job!",
        "Great work!",
        "One step closer to home",
        "Hooray!",
        "See that wasn't too hard",

    ],
    [
        "Whoops!",
        """
        "Better hope you didn't leave
        the stove on back at home...
        """,
        
        """
        Third time is the charm? 
        No?
        """,
        "Never give up!",
        "So close!",
    ]
]

class GameScene: SKScene, SKPhysicsContactDelegate {
    var mainView: MainView?

    override init(size: CGSize) {
        self.mainView = nil
        super.init(size: size)
    }

    convenience init(size: CGSize, mainView: MainView) {
        self.init(size: size)
        self.mainView = mainView
    }

    required init?(coder aDecoder: NSCoder) {
        self.mainView = nil
        super.init(coder: aDecoder)
    }
        
    var numberOfStars = 300
    var stars = SKEmitterNode(fileNamed: "stars")!

    var laserSound = createSound(filePath: "pew-pew.wav")
    
    var lootBox = SKSpriteNode(imageNamed: "LootBox")
    var jumpgate = SKSpriteNode(imageNamed: "LootBox")
    var asteroid = SKSpriteNode(imageNamed: "Asteroid")
    let asteroidTrails = SKEmitterNode(fileNamed: "asteroidTrails")!

    var gameOverLabel = SKLabelNode(text: "")
    
    //spaceship related stuff
    var spaceship = SKSpriteNode(imageNamed: "Spaceship")
    let spaceshipTrail = SKEmitterNode(fileNamed: "spaceshipTrails")!
    
    var shields = SKSpriteNode(imageNamed: "Shield")
    
    var spaceshipMovingForward = false
    //-----------------------

    var scoreForJumpgate = 10

    var scoreNode = SKLabelNode()
    var score = 0
    
    var lanes:[SKSpriteNode] = []
    var currentLane = 2

    var numberOfLanes = 5
    var laneGap: CGFloat = 2
    var laneWidth: Double = 0.0
    
    var lasers: [SKSpriteNode] = []
    var lootBoxes: [SKSpriteNode] = []
    
    var lootBoxLanesNumber: Int = 0
    var lootBoxLanes: [Int] = []
    var lootBoxLane: Int? = 0
    
    var currentJumpgateLane = -1
    
    var asteroidLanes: [Bool] = []
    var asteroidLane = -1
        
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, -30);
        
        initialisation()
    }
    
    func initialisation(){

        //set bg color
        backgroundColor = .black
        stars.particleBirthRate = 300
        stars.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        stars.zPosition = -1
        addChild(stars)
        
        //asteroid trails
        
        addChild(asteroidTrails)
        asteroidTrails.position = CGPoint(x: -100, y: -100)
        
        //generate lanes
        laneWidth = (frame.size.width-laneGap*4)/Double(numberOfLanes)
        var xPosition = laneWidth/2
        for _ in 1...numberOfLanes{
            let lane = SKSpriteNode(imageNamed: "Lane")
            lane.name = "lane"
            lane.size = CGSize(width: laneWidth, height: frame.size.height)
            lane.position = CGPoint(x: xPosition, y: frame.size.height / 2)
            lanes.append(lane)
            addChild(lane)
            xPosition += laneGap + laneWidth
            
        }
        
        spaceship.name = "spaceship"
        spaceship.position = CGPoint(x: lanes[currentLane].position.x, y: 100)
        spaceship.size = CGSize(width: laneWidth*0.8, height: laneWidth*0.8)
        spaceship.zPosition = 2
        
        spaceship.physicsBody = SKPhysicsBody(rectangleOf: spaceship.size)
        spaceship.physicsBody?.affectedByGravity = false
        spaceship.physicsBody?.isDynamic = true

        spaceship.physicsBody?.categoryBitMask = PhysicsCategory.spaceship
        spaceship.physicsBody?.collisionBitMask = 0
        spaceship.physicsBody?.contactTestBitMask = PhysicsCategory.jumpgate
        
        
        addChild(spaceship)
        
        //spaceship trails
        spaceshipTrail.particleTexture = SKTexture(imageNamed: "Asteroid")
        spaceshipTrail.particleScale = 0.15

        spaceshipTrail.position = CGPoint(x: spaceship.position.x, y: spaceship.position.y-spaceship.size.height*0.4)
        spaceshipTrail.zPosition = -1

        spaceshipTrail.particleBirthRate = 500
        spaceshipTrail.yAcceleration = -50

        addChild(spaceshipTrail)
        
        scoreNode.text = String(score)
        scoreNode.position = CGPoint(x: frame.size.width*0.9, y: frame.size.height*0.9)
        scoreNode.fontSize = 24
        scoreNode.fontName = "AvenirNext-Bold"
        scoreNode.zPosition = 1000
        
        addChild(scoreNode)
        
        gameOverLabel.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        gameOverLabel.fontSize = 36
        gameOverLabel.lineBreakMode = .byCharWrapping
        gameOverLabel.fontName = "Futura-Bold"
        gameOverLabel.zPosition = 10000
        
        addChild(gameOverLabel)
        
        shields.size = CGSize(width: laneWidth*2, height: (laneWidth*2) * 0.35)
        
        shields.physicsBody = SKPhysicsBody(rectangleOf: shields.size)
        shields.physicsBody?.affectedByGravity = false
        shields.physicsBody?.isDynamic = true

        shields.physicsBody?.categoryBitMask = PhysicsCategory.shields
        shields.physicsBody?.collisionBitMask = 0
        shields.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid

    }
    
    override func update(_ currentTime: TimeInterval) {
//        print(contentView?.running ?? false)
        for laser in lasers{
            laser.position.y += 25
        }
        
        if spaceshipMovingForward{
            spaceship.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2))
        }

        if score >= scoreForJumpgate && currentJumpgateLane > -1{
            lootBox.removeFromParent()
            spawnJumpgate(lane: currentJumpgateLane)
        }
        
        //updated manually as i want the trail to be affected by movement
        spaceshipTrail.position = CGPoint(x: spaceship.position.x, y: spaceship.position.y-spaceship.size.height*0.35)

//        if !mainView!.running {
//            
//        }
        
//        if asteroid.position.y < 0{
//            asteroid.removeFromParent()
//        }
        
        if asteroid.parent != nil{
            asteroidTrails.position = CGPoint(x: asteroid.position.x, y: asteroid.position.y - asteroid.size.height/2)
        }
        else{
            asteroidTrails.position = CGPoint(x: -100, y: -100)
        }
    }
    
    func reset(){

        
        gameOverLabel.text = ""
        
        spaceship.texture = SKTexture(imageNamed: "Spaceship")
        spaceshipMovingForward = false

        spaceshipTrail.particleScale = 0.15
        spaceshipTrail.particleBirthRate = 500
        spaceshipTrail.yAcceleration = -50
        
        lootBoxLanesNumber = 0
        score = 0
        currentLane = 2
        
        lasers.removeAll()
        spaceship.removeAllChildren()
        self.removeAllChildren()
        
        initialisation()
        mainView?.running = true


    }
    
    func moveSpaceship(moveDirection: MoveDirection) async {
        try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))

        switch moveDirection {
        case .front:
            return
        case .left:
            
            if currentLane-1 >= 0{
                currentLane -= 1
                
                let moveAction = SKAction.move(to: CGPoint(x: lanes[currentLane].position.x, y: 100), duration: 0.5)
                await withCheckedContinuation { continuation in
                    spaceship.run(moveAction, completion: {
                        continuation.resume()
                    })
                }
            }
            else{
                let moveAction = SKAction.sequence([
                    SKAction.move(to: CGPoint(x: 0, y: 100), duration: 0.25),
                    SKAction.move(to: CGPoint(x: self.lanes[self.currentLane].position.x, y: 100), duration: 0.1)
                ])
                await withCheckedContinuation { continuation in
                    spaceship.run(moveAction, completion: {
                        continuation.resume()
                    })
                }
                
            }
            
            
        case .right:
            if currentLane+1 < lanes.count{
                currentLane += 1
                
                let moveAction = SKAction.move(to: CGPoint(x: lanes[currentLane].position.x, y: 100), duration: 0.5)
                await withCheckedContinuation { continuation in
                    spaceship.run(moveAction, completion: {
                        continuation.resume()
                    })
                }
            }
            else{
                let moveAction = SKAction.sequence([
                    SKAction.move(to: CGPoint(x: frame.size.width, y: 100), duration: 0.25),
                    SKAction.move(to: CGPoint(x: self.lanes[self.currentLane].position.x, y: 100), duration: 0.1)
                ])
                await withCheckedContinuation { continuation in
                    spaceship.run(moveAction, completion: {
                        continuation.resume()
                    })
                }
                
            }
        }
        
        if currentLane == lootBoxLane{
            if asteroidLanes[lootBoxLanesNumber]{
                spawnAsteroid(lane: lootBoxLane!)
            }

//            if asteroidLanes[asteroidLanesNumber] != -1{
//                asteroid.removeFromParent()
//            }
//            else{
//                asteroid.removeFromParent()
//            }

        }
        
    }
    
    func moveToJumpgate() async {
        try? await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))
        
        if currentLane == currentJumpgateLane{
            spaceshipTrail.particleScale = 0.25
            spaceshipTrail.particleBirthRate = 1000
            spaceshipTrail.yAcceleration = -500
            
            spaceshipMovingForward = true
            currentJumpgateLane = -1
            
            if (asteroid.parent != nil){
                asteroid.removeFromParent()
            }
            
            stars.particleBirthRate = 0
            
        }
    }
    
    
    var shootFromRight = true
    func shoot() async {
        
        try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
        
        let laser = SKSpriteNode(imageNamed: "PlayerLaser")
        laser.name = "laser"
        
        laser.position = CGPoint(x: shootFromRight ? spaceship.position.x + 10 : spaceship.position.x - 10, y: spaceship.position.y+100)
        shootFromRight.toggle()
        
        laser.zPosition = spaceship.zPosition - 1
        laser.size = CGSize(width: 2, height: 50)
        
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.affectedByGravity = false
//        laser.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        
        laser.physicsBody?.categoryBitMask = PhysicsCategory.laser
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.lootBox
        
        lasers.append(laser)
        
        addChild(laser)
        
        laserSound?.volume = 0.3
        laserSound?.play()
        
    }
    
    func destroyLootBox() {
        score += 1
        scoreNode.text = String(score)
        
        if score < scoreForJumpgate{
            spawnLootBox(lane: lootBoxLanes[lootBoxLanesNumber])
        }
        lootBoxLanesNumber += 1
    }
    
    func spawnLootBox(lane: Int) {
        lootBox.removeFromParent()
        let newLootBox = SKSpriteNode(imageNamed: "LootBox")
        newLootBox.name = "lootBox"
        newLootBox.size = CGSize(width: laneWidth*0.7, height: laneWidth*0.7)

        newLootBox.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newLootBox.size.width*0.5, height: newLootBox.size.height*0.5))
        newLootBox.physicsBody?.affectedByGravity = false
        newLootBox.physicsBody?.isDynamic = true
        newLootBox.physicsBody?.categoryBitMask = PhysicsCategory.lootBox
        newLootBox.physicsBody?.collisionBitMask = 0
        newLootBox.physicsBody?.contactTestBitMask = PhysicsCategory.laser

        newLootBox.position = CGPoint(x: lanes[lane].position.x, y: frame.size.height*0.85)

        addChild(newLootBox)

        lootBox = newLootBox
        lootBox.zPosition = 50

        lootBoxLane = lane
    }
    
    func spawnJumpgate(lane: Int){
        jumpgate.removeFromParent()
        let newJumpgate = SKSpriteNode(imageNamed: "Jumpgate")
        newJumpgate.name = "jumpgate"
        newJumpgate.size = CGSize(width: laneWidth, height: laneWidth)
        
        newJumpgate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newJumpgate.size.width*0.1, height: newJumpgate.size.height*0.1))
        newJumpgate.physicsBody?.affectedByGravity = false
        newJumpgate.physicsBody?.isDynamic = true
        newJumpgate.physicsBody?.categoryBitMask = PhysicsCategory.jumpgate
        newJumpgate.physicsBody?.collisionBitMask = 0
        newJumpgate.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
        
        newJumpgate.position = CGPoint(x: lanes[lane].position.x, y: frame.size.height*0.85)
        newJumpgate.zPosition = 50
        
        addChild(newJumpgate)
        
        jumpgate = newJumpgate
    }
    
    func spawnAsteroid(lane: Int) {
        asteroid.removeFromParent()
        
        if lane != -1{
            
            let newAsteroid = SKSpriteNode(imageNamed: "Asteroid")
            newAsteroid.name = "asteroid"
            newAsteroid.size = CGSize(width: laneWidth*0.5, height: (laneWidth*0.5))
            
            newAsteroid.physicsBody = SKPhysicsBody(rectangleOf: newAsteroid.size)
            newAsteroid.physicsBody?.affectedByGravity = true
            newAsteroid.physicsBody?.isDynamic = true
            newAsteroid.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
            newAsteroid.physicsBody?.collisionBitMask = 0
            newAsteroid.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
            
            newAsteroid.position = CGPoint(x: lanes[lane].position.x, y: frame.size.height + newAsteroid.size.height / 2)
            addChild(newAsteroid)
            
            asteroid = newAsteroid
            asteroid.zPosition = 52

            asteroidLane = lane
        }
    }
    
    func activateShields(){
        if (shields.parent != nil){
            shields.removeFromParent()
        }
        shields.position = CGPoint(x: spaceship.position.x, y: spaceship.position.y + 75)
        addChild(shields)
        
    }
    
    func spaceShipExplode() {
        Task{
            mainView?.runTask?.cancel()
            mainView?.running = false
            
            spaceshipTrail.removeFromParent()
            spaceship.removeFromParent()

//            spaceship.removeAllActions()
//            spaceship.texture = nil
            

            //explosion effect
            let emitter = SKEmitterNode(fileNamed: "explosion")!
            emitter.particleTexture = SKTexture(imageNamed: "Star")
            
            emitter.position = spaceship.position
            
            emitter.particleBirthRate = 100

            addChild(emitter)
            try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
            emitter.particleBirthRate = 0
            try? await Task.sleep(nanoseconds: UInt64(2.5 * 1_000_000_000))
            emitter.removeFromParent()



        }
        
    }
    
    func destroyAsteroid(){
        Task{
            let shieldImpactEffect = SKEmitterNode(fileNamed: "shieldImpact")!
            shieldImpactEffect.position = asteroid.position
            asteroid.removeFromParent()
            
            try? await Task.sleep(nanoseconds: UInt64(0.1 * 1_000_000_000))
            shieldImpactEffect.particleBirthRate = 0
            try? await Task.sleep(nanoseconds: UInt64(2.5 * 1_000_000_000))
            shieldImpactEffect.removeFromParent()
        }
    }
    
    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, containerFrame:CGSize) {

        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(containerFrame.width / labelNode.frame.width, containerFrame.height / labelNode.frame.height)

        // Change the fontSize.
        labelNode.fontSize *= scalingFactor

        // Optionally move the SKLabelNode to the center of the rectangle.
        labelNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {


        var BodyA = contact.bodyA
        var BodyB = contact.bodyB
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            BodyA = contact.bodyA
            BodyB = contact.bodyB
        }
        else{
            BodyA = contact.bodyB
            BodyB = contact.bodyA
        }
        
        print("BodyA", BodyA.categoryBitMask)
        print("BodyB", BodyB.categoryBitMask)
        
        if (BodyA.categoryBitMask == PhysicsCategory.laser && BodyB.categoryBitMask == PhysicsCategory.lootBox){
            laserSound?.play()
            print("boom goes the lootbox")
            destroyLootBox()
            BodyA.node?.removeFromParent()
            
        }
        if (BodyA.categoryBitMask == PhysicsCategory.spaceship && BodyB.categoryBitMask == PhysicsCategory.jumpgate){
            print("boom goes the jumpgate")

            jumpgate.removeFromParent()
            spaceshipMovingForward = false
            
            
            gameOverLabel.text = GameOverTexts[0][Int.random(in: 0..<GameOverTexts[0].count)]
            adjustLabelFontSizeToFitRect(labelNode: gameOverLabel, containerFrame: CGSize(width: frame.size.width*0.8, height: frame.size.height))
            mainView?.running = false

            mainView?.levelWon = true

        }
        if (BodyA.categoryBitMask == PhysicsCategory.spaceship && BodyB.categoryBitMask == PhysicsCategory.asteroid){
            print("boom goes the spaceship")
            
            gameOverLabel.text = GameOverTexts[1][Int.random(in: 0..<GameOverTexts[1].count)]
            adjustLabelFontSizeToFitRect(labelNode: gameOverLabel, containerFrame: CGSize(width: frame.size.width*0.8, height: frame.size.height))
            
            spaceShipExplode()
        }
        if (BodyA.categoryBitMask == PhysicsCategory.shields && BodyB.categoryBitMask == PhysicsCategory.asteroid){
            laserSound?.play()
            print("boom goes the asteroid")
            
            destroyAsteroid()
            shields.removeFromParent()
        }
    }
}


