import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Einrichten der SpriteKit-Szene
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // Hintergrundfarbe
        backgroundColor = UIColor.white
        
        // Punktzahl-Label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 20
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height-40)
        scoreLabel.horizontalAlignmentMode = .center
        addChild(scoreLabel)
        
        // Spielobjekte
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.position = CGPoint(x: size.width/2, y: size.height-100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.isDynamic = true
        addChild(ball)
        
        let player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: size.width/2, y: 50)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        addChild(player)
        
        // Kontakt-Detektor
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        // Ball-Fall-Animation
        let fallAction = SKAction.move(to: CGPoint(x: ball.position.x, y: -50), duration: 3)
        ball.run(fallAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Wenn der Ball den Spieler trifft
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "player" {
            score += 1
            contact.bodyA.node?.removeFromParent()
        }
        // Wenn der Ball den Boden erreicht
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "ground" {
            gameOver()
        }
    }
    
    func gameOver() {
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 40
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
    }
}
