import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate{
    
    var scoreLabel: SKLabelNode!
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel : SKLabelNode!
    
    var editingMode: Bool = false{
        didSet{
            if editingMode{
                editLabel.text = "Done"
            }
            else{
                editLabel.text = "Edit"
            }
        }
    }
    
    
    
    
    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "background@2x.jpg")
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.contactDelegate = self
////
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        scoreLabel = SKLabelNode(fontNamed: "Named")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Named2")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        let size = CGSize(width: 1024, height:  5)
        let box = SKSpriteNode(color: .green, size: size)
        box.position = CGPoint(x: 512, y: 384)
        addChild(box)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return  }
        guard let nodeB = contact.bodyB.node else { return  }
        
        if nodeA.name == "ball"{
            collisionBetween(ball: nodeA, object: nodeB)
            
        }
        else if nodeB.name == "ball"{
            collisionBetween(ball: nodeB, object: nodeA)
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            if objects.contains(editLabel){
                editingMode.toggle()
            }
            else if editingMode{
                let size = CGSize(width: Int.random(in: 16...128), height:  16)
                let box = SKSpriteNode(
                    color: UIColor(
                        red: CGFloat.random(in: 0...1),
                        green: CGFloat.random(in: 0...1),
                        blue: CGFloat.random(in: 0...1),
                        alpha:1
                    ),
                    size: size)
                box.position = location
                box.zRotation = CGFloat.random(in: 0...3)
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            }
            else {
                if location.y >= 384{
                    makeBall(at: location)
                }
                
            }
            
//            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
//            box.position = location
//            addChild(box)
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            
            
        }
        
    }
    
    func makeBall(at position: CGPoint){
        let numberColor = Int.random(in: 0...6)
        let ball : SKSpriteNode
        switch numberColor{
            case 0:
                ball = SKSpriteNode(imageNamed: "ballRed")
            case 1:
                ball = SKSpriteNode(imageNamed: "ballBlue")
            case 2:
                ball = SKSpriteNode(imageNamed: "ballCyan")
            case 3:
                ball = SKSpriteNode(imageNamed: "ballGreen")
            case 4:
                ball = SKSpriteNode(imageNamed: "ballGrey")
            case 5:
                ball = SKSpriteNode(imageNamed: "ballPurple")
            case 6:
                ball = SKSpriteNode(imageNamed: "ballYellow")
            
            default:
                ball = SKSpriteNode(imageNamed: "ballRed")
               
        }
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.restitution = 0.4
        ball.position = position
        ball.name = "ball"
        addChild(ball)

    }
    
    
    func makeBouncer(at position: CGPoint){
        
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        
        addChild(bouncer)
    }
    
    
    
    
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
            
        }
        slotBase.position = position
        slotGlow.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: -.pi, duration: 10)
        
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
        }
        else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
        }
    }
    func destroy(ball : SKNode){
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    
}
