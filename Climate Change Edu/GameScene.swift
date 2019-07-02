//
//  AppDelegate.swift
//  Climate Change Edu
//
//  Created by Patrick Moore on 5/15/19.
//  Copyright © 2019 Patrick Moore. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //declaring varables used to stare game-data
    var game: GameManager!
    var climateBG: SKShapeNode!
    var weatherBG: SKShapeNode!
    var enviromBG: SKShapeNode!
    var cwBG: SKShapeNode!
    var weBG: SKShapeNode!
    var ceBG: SKShapeNode!
    var cweBG: SKShapeNode!
    var tile1: SKShapeNode!
    var tile2: SKShapeNode!
    var tile3: SKShapeNode!
    var tile4: SKShapeNode!
    var tile5: SKShapeNode!
    var tile6: SKShapeNode!
    var tile7: SKShapeNode!
    var tile8: SKShapeNode!
    var tile9: SKShapeNode!
    var tile10: SKShapeNode!
    var tile11: SKShapeNode!
    var tile12: SKShapeNode!
    var tile13: SKShapeNode!
    var tile14: SKShapeNode!
    var tile15: SKShapeNode!
    
    
    // Function runs on start of the aplication
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager(scene: self)
    }
    
    // Function runs on screen touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-click functionality here
    }
    
    private func initializeMenu() {
        // Declaring constants to determine object sizing
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        // Determines ratio
        let ratio: CGFloat = (screenWidth / CGFloat(850))
        let circleWidth: CGFloat = (ratio * CGFloat(270))
        let barWidth: CGFloat = ratio * 110
        let barLength: CGFloat = ratio * CGFloat(550)
        let bottomMargin: CGFloat = ((screenHeight / -2) + (0.6 * circleWidth))
        let midMargin: CGFloat = ((3 / 4) * barLength * barLength).squareRoot()
        // Declares size of tiles
        let tileLength: CGFloat = ((1/9) * 850 * ratio)
        let tileHeight: CGFloat = (tileLength / 2)
        // Declares center of the 3 circles as anchor points
        let p1 = CGPoint(x: (barLength / -2), y: bottomMargin + midMargin)
        let p2 = CGPoint(x: (barLength / 2), y: bottomMargin + midMargin)
        let p3 = CGPoint(x: 0, y: bottomMargin)
        // Create Common Area
        cweBG = SKShapeNode()
        cweBG.position = CGPoint(x: 0, y: 0)
        cweBG.zPosition = 1
        let path1 = CGMutablePath()
        path1.addLines(between: [p1, p2, p3])
        cweBG.path = path1
        cweBG.fillColor = SKColor.white
        cweBG.name = "cwe_space"
        self.addChild(cweBG)
        // Create Combo Area
        cwBG = SKShapeNode()
        cwBG.position = CGPoint(x: 0, y: 0)
        cwBG.zPosition = 2
        let path2 = CGMutablePath()
        let cwBar: [CGPoint] = [CGPoint(x: p1.x, y: p1.y + (barWidth / 2)), CGPoint(x: p2.x, y: p2.y + (barWidth / 2)), CGPoint(x: p2.x, y: p2.y - (barWidth / 2)), CGPoint(x: p1.x, y: p1.y - (barWidth / 2))]
        path2.addLines(between: [cwBar[0], cwBar[1], cwBar[2], cwBar[3]])
        cwBG.path = path2
        cwBG.fillColor = SKColor.magenta
        cwBG.strokeColor = SKColor.black
        cwBG.lineWidth = 4 * ratio
        cwBG.name = "cw_space"
        self.addChild(cwBG)
        // Create Combo Area
        ceBG = SKShapeNode()
        ceBG.position = CGPoint(x: 0, y: 0)
        ceBG.zPosition = 2
        let path3 = CGMutablePath()
        let ceBar: [CGPoint] = [CGPoint(x: p1.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p1.y + (barWidth / 4)), CGPoint(x: p3.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y + (barWidth / 4)), CGPoint(x: p3.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y - (barWidth / 4)), CGPoint(x: p1.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p1.y - (barWidth / 4))]
        path3.addLines(between: [ceBar[0], ceBar[1], ceBar[2], ceBar[3]])
        ceBG.path = path3
        ceBG.fillColor = SKColor.cyan
        ceBG.strokeColor = SKColor.black
        ceBG.lineWidth = 4 * ratio
        ceBG.name = "ce_space"
        self.addChild(ceBG)
        // Create Combo Area
        weBG = SKShapeNode()
        weBG.position = CGPoint(x: 0, y: 0)
        weBG.zPosition = 2
        let path4 = CGMutablePath()
        let weBar: [CGPoint] = [CGPoint(x: p3.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y - (barWidth / 4)), CGPoint(x: p2.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p2.y - (barWidth / 4)), CGPoint(x: p2.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p2.y + (barWidth / 4)), CGPoint(x: p3.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y + (barWidth / 4))]
        path4.addLines(between: [weBar[0], weBar[1], weBar[2], weBar[3]])
        weBG.path = path4
        weBG.fillColor = SKColor.yellow
        weBG.strokeColor = SKColor.black
        weBG.lineWidth = 4 * ratio
        weBG.name = "we_space"
        self.addChild(weBG)
        // Create Climate Circle
        climateBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        climateBG.position = p1
        climateBG.zPosition = 3
        climateBG.fillColor = SKColor.blue
        climateBG.strokeColor = SKColor.black
        climateBG.lineWidth = 4 * ratio
        climateBG.name = "c_space"
        self.addChild(climateBG)
        // Create Weather Circle
        weatherBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        weatherBG.position = p2
        weatherBG.zPosition = 3
        weatherBG.fillColor = SKColor.red
        weatherBG.strokeColor = SKColor.black
        weatherBG.lineWidth = 4 * ratio
        weatherBG.name = "w_space"
        self.addChild(weatherBG)
        // Create Enviroment Circle
        enviromBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        enviromBG.position = p3
        enviromBG.zPosition = 3
        enviromBG.fillColor = SKColor.green
        enviromBG.strokeColor = SKColor.black
        enviromBG.lineWidth = 4 * ratio
        enviromBG.name = "e_space"
        self.addChild(enviromBG)
        // Create Immobile Circle Labels
        let cLabel = SKLabelNode(fontNamed: "ArialMT")
        let wLabel = SKLabelNode(fontNamed: "ArialMT")
        let eLabel = SKLabelNode(fontNamed: "ArialMT")
        cLabel.text = "Climate"
        wLabel.text = "Weather"
        eLabel.text = "Enviroment"
        cLabel.fontSize = 50 * ratio
        wLabel.fontSize = 50 * ratio
        eLabel.fontSize = 50 * ratio
        cLabel.position = CGPoint(x: climateBG.frame.midX, y: climateBG.frame.midY - (cLabel.fontSize / 2))
        wLabel.position = CGPoint(x: weatherBG.frame.midX, y: weatherBG.frame.midY - (cLabel.fontSize / 2))
        eLabel.position = CGPoint(x: enviromBG.frame.midX, y: enviromBG.frame.midY - (cLabel.fontSize / 2))
        cLabel.zPosition = 4
        wLabel.zPosition = 4
        eLabel.zPosition = 4
        self.addChild(cLabel)
        self.addChild(wLabel)
        self.addChild(eLabel)
        // Create Immobile Bar Labels
        let cwLabel1 = SKLabelNode(fontNamed: "ArialMT")
        let cwLabel2 = SKLabelNode(fontNamed: "ArialMT")
        cwLabel1.text = "Climate and"
        cwLabel2.text = "Weather"
        cwLabel1.fontSize = 30 * ratio
        cwLabel2.fontSize = 30 * ratio
        cwLabel1.position = CGPoint(x: cwBG.frame.midX, y: cwBG.frame.midY + (cwLabel1.fontSize * 0.2))
        cwLabel2.position = CGPoint(x: cwBG.frame.midX, y: cwBG.frame.midY - (cwLabel2.fontSize * 1.2))
        cwLabel1.zPosition = 4
        cwLabel2.zPosition = 4
        cwLabel1.fontColor = SKColor.black
        cwLabel2.fontColor = SKColor.black
        self.addChild(cwLabel1)
        self.addChild(cwLabel2)
        let ceLabel1 = SKLabelNode(fontNamed: "ArialMT")
        let ceLabel2 = SKLabelNode(fontNamed: "ArialMT")
        ceLabel1.text = "Climate and"
        ceLabel2.text = "Enviroment"
        ceLabel1.fontSize = 30 * ratio
        ceLabel2.fontSize = 30 * ratio
        ceLabel1.position = CGPoint(x: ceBG.frame.midX + (ceLabel1.fontSize * 0.2 * CGFloat(3).squareRoot()), y: ceBG.frame.midY + (ceLabel1.fontSize * 0.2))
        ceLabel2.position = CGPoint(x: ceBG.frame.midX - (ceLabel2.fontSize * 0.5 * CGFloat(3).squareRoot()), y: ceBG.frame.midY - (ceLabel2.fontSize * 0.5))
        ceLabel1.zPosition = 4
        ceLabel2.zPosition = 4
        ceLabel1.fontColor = SKColor.black
        ceLabel2.fontColor = SKColor.black
        ceLabel1.zRotation = -60 * CGFloat.pi / 180
        ceLabel2.zRotation = -60 * CGFloat.pi / 180
        self.addChild(ceLabel1)
        self.addChild(ceLabel2)
        let weLabel1 = SKLabelNode(fontNamed: "ArialMT")
        let weLabel2 = SKLabelNode(fontNamed: "ArialMT")
        weLabel1.text = "Enviroment"
        weLabel2.text = "and Weather"
        weLabel1.fontSize = 30 * ratio
        weLabel2.fontSize = 30 * ratio
        weLabel1.position = CGPoint(x: weBG.frame.midX - (weLabel1.fontSize * 0.2 * CGFloat(3).squareRoot()), y: weBG.frame.midY + (weLabel1.fontSize * 0.2))
        weLabel2.position = CGPoint(x: weBG.frame.midX + (weLabel2.fontSize * 0.5 * CGFloat(3).squareRoot()), y: weBG.frame.midY - (weLabel2.fontSize * 0.5))
        weLabel1.zPosition = 4
        weLabel2.zPosition = 4
        weLabel1.fontColor = SKColor.black
        weLabel2.fontColor = SKColor.black
        weLabel1.zRotation = 60 * CGFloat.pi / 180
        weLabel2.zRotation = 60 * CGFloat.pi / 180
        self.addChild(weLabel1)
        self.addChild(weLabel2)
        let cweLabel1 = SKLabelNode(fontNamed: "ArialMT")
        let cweLabel2 = SKLabelNode(fontNamed: "ArialMT")
        let cweLabel3 = SKLabelNode(fontNamed: "ArialMT")
        cweLabel1.text = "Enviroment and"
        cweLabel2.text = "Weather and"
        cweLabel3.text = "Climate"
        cweLabel1.fontSize = 30 * ratio
        cweLabel2.fontSize = 30 * ratio
        cweLabel3.fontSize = 30 * ratio
        cweLabel1.position = CGPoint(x: cweBG.frame.midX, y: cweBG.frame.midY + (cweLabel1.fontSize * 3.8))
        cweLabel2.position = CGPoint(x: cweBG.frame.midX, y: cweBG.frame.midY + (cweLabel2.fontSize * 2.4))
        cweLabel3.position = CGPoint(x: cweBG.frame.midX, y: cweBG.frame.midY + (cweLabel3.fontSize * 1.0))
        cweLabel1.zPosition = 4
        cweLabel2.zPosition = 4
        cweLabel3.zPosition = 4
        cweLabel1.fontColor = SKColor.black
        cweLabel2.fontColor = SKColor.black
        cweLabel3.fontColor = SKColor.black
        self.addChild(cweLabel1)
        self.addChild(cweLabel2)
        self.addChild(cweLabel3)
        let naLabel1 = SKLabelNode(fontNamed: "ArialMT")
        let naLabel2 = SKLabelNode(fontNamed: "ArialMT")
        let naLabel3 = SKLabelNode(fontNamed: "ArialMT")
        let naLabel4 = SKLabelNode(fontNamed: "ArialMT")
        naLabel1.text = "unrelated"
        naLabel2.text = "unrelated"
        naLabel3.text = "unrelated"
        naLabel4.text = "unrelated"
        naLabel1.fontSize = 30 * ratio
        naLabel2.fontSize = 30 * ratio
        naLabel3.fontSize = 30 * ratio
        naLabel4.fontSize = 30 * ratio
        naLabel1.position = CGPoint(x: 7 * screenWidth / 20, y: (weatherBG.frame.midY + (3 * enviromBG.frame.midY)) / 4)
        naLabel2.position = CGPoint(x: 7 * screenWidth / -20, y: (weatherBG.frame.midY + (3 * enviromBG.frame.midY)) / 4)
        naLabel3.position = CGPoint(x: 7 * screenWidth / 20, y: (enviromBG.frame.midY - screenHeight) / 3)
        naLabel4.position = CGPoint(x: 7 * screenWidth / -20, y: (enviromBG.frame.midY - screenHeight) / 3)
        naLabel1.zPosition = 4
        naLabel2.zPosition = 4
        naLabel3.zPosition = 4
        naLabel4.zPosition = 4
        naLabel1.fontColor = SKColor.black
        naLabel2.fontColor = SKColor.black
        naLabel3.fontColor = SKColor.black
        naLabel4.fontColor = SKColor.black
        self.addChild(naLabel1)
        self.addChild(naLabel2)
        self.addChild(naLabel3)
        self.addChild(naLabel4)
        let tileMin = bottomMargin + midMargin + (0.6 * circleWidth)
        let tileMax = screenHeight / 2
        let tileOffsetX = tileLength / -2
        let tileBufferX = screenWidth / 6
        tile1 = SKShapeNode.init(rect: CGRect(x: tileOffsetX - (2 * tileBufferX), y: (tileMin / 4) + (3 * tileMax / 4), width: tileLength, height: tileHeight))
        tile2 = SKShapeNode.init(rect: CGRect(x: tileOffsetX - tileBufferX, y: (tileMin / 4) + (3 * tileMax / 4), width: tileLength, height: tileHeight))
        tile3 = SKShapeNode.init(rect: CGRect(x: tileOffsetX, y: (tileMin / 4) + (3 * tileMax / 4), width: tileLength, height: tileHeight))
        tile4 = SKShapeNode.init(rect: CGRect(x: tileOffsetX + tileBufferX, y: (tileMin / 4) + (3 * tileMax / 4), width: tileLength, height: tileHeight))
        tile5 = SKShapeNode.init(rect: CGRect(x: tileOffsetX + (2 * tileBufferX), y: (tileMin / 4) + (3 * tileMax / 4), width: tileLength, height: tileHeight))
        tile6 = SKShapeNode.init(rect: CGRect(x: tileOffsetX - (2 * tileBufferX), y: (tileMin + tileMax) / 2, width: tileLength, height: tileHeight))
        tile7 = SKShapeNode.init(rect: CGRect(x: tileOffsetX - tileBufferX, y: (tileMin + tileMax) / 2, width: tileLength, height: tileHeight))
        tile8 = SKShapeNode.init(rect: CGRect(x: tileOffsetX, y: (tileMin + tileMax) / 2, width: tileLength, height: tileHeight))
        tile9 = SKShapeNode.init(rect: CGRect(x: tileOffsetX + tileBufferX, y: (tileMin + tileMax) / 2, width: tileLength, height: tileHeight))
        tile10 = SKShapeNode.init(rect: CGRect(x: tileOffsetX + (2 * tileBufferX), y: (tileMin + tileMax) / 2, width: tileLength, height: tileHeight))
        tile11 = SKShapeNode.init(rect: CGRect(x: tileOffsetX - (2 * tileBufferX), y: (3 * tileMin / 4) + (tileMax / 4), width: tileLength, height: tileHeight))
        tile12 = SKShapeNode.init(rect: CGRect(x: tileOffsetX - tileBufferX, y: (3 * tileMin / 4) + (tileMax / 4), width: tileLength, height: tileHeight))
        tile13 = SKShapeNode.init(rect: CGRect(x: tileOffsetX, y: (3 * tileMin / 4) + (tileMax / 4), width: tileLength, height: tileHeight))
        tile14 = SKShapeNode.init(rect: CGRect(x: tileOffsetX + tileBufferX, y: (3 * tileMin / 4) + (tileMax / 4), width: tileLength, height: tileHeight))
        tile15 = SKShapeNode.init(rect: CGRect(x: tileOffsetX + (2 * tileBufferX), y: (3 * tileMin / 4) + (tileMax / 4), width: tileLength, height: tileHeight))
        self.addChild(tile1)
        self.addChild(tile2)
        self.addChild(tile3)
        self.addChild(tile4)
        self.addChild(tile5)
        self.addChild(tile6)
        self.addChild(tile7)
        self.addChild(tile8)
        self.addChild(tile9)
        self.addChild(tile10)
        self.addChild(tile11)
        self.addChild(tile12)
        self.addChild(tile13)
        self.addChild(tile14)
        self.addChild(tile15)
    }
}
