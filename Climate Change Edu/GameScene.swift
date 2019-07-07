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
    var tileLabel1: SKLabelNode!
    var tileLabel2: SKLabelNode!
    var tileLabel3: SKLabelNode!
    var tileLabel4: SKLabelNode!
    var tileLabel5: SKLabelNode!
    var tileLabel6: SKLabelNode!
    var tileLabel7: SKLabelNode!
    var tileLabel8: SKLabelNode!
    var tileLabel9: SKLabelNode!
    var tileLabel10: SKLabelNode!
    var tileLabel11: SKLabelNode!
    var tileLabel12: SKLabelNode!
    var tileLabel13: SKLabelNode!
    var tileLabel14: SKLabelNode!
    var tileLabel15: SKLabelNode!
    var nodeToMove: SKNode!
    var nodeLabelToMove: SKNode!
    var locationOld: CGPoint!
    var zPosUpdater: CGFloat!
    
    // Function runs on start of the aplication
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager(scene: self)
        zPosUpdater = 7
    }
    
    // Function runs on initial screen touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-click functionality here
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "tile" {
                    nodeToMove = node
                    locationOld = location
                    break
                }
            }
            switch nodeToMove {
                case tile1:
                    nodeLabelToMove = tileLabel1
                    break
                case tile2:
                    nodeLabelToMove = tileLabel2
                    break
                case tile3:
                    nodeLabelToMove = tileLabel3
                    break
                case tile4:
                    nodeLabelToMove = tileLabel4
                    break
                case tile5:
                    nodeLabelToMove = tileLabel5
                    break
                case tile6:
                    nodeLabelToMove = tileLabel6
                    break
                case tile7:
                    nodeLabelToMove = tileLabel7
                    break
                case tile8:
                    nodeLabelToMove = tileLabel8
                    break
                case tile9:
                    nodeLabelToMove = tileLabel9
                    break
                case tile10:
                    nodeLabelToMove = tileLabel10
                    break
                case tile11:
                    nodeLabelToMove = tileLabel11
                    break
                case tile12:
                    nodeLabelToMove = tileLabel12
                    break
                case tile13:
                    nodeLabelToMove = tileLabel13
                    break
                case tile14:
                    nodeLabelToMove = tileLabel14
                    break
                case tile15:
                    nodeLabelToMove = tileLabel15
                    break
                case .none:
                    break
                case .some(_):
                    break
            }
            if nodeToMove != nil {
                nodeToMove.zPosition = zPosUpdater
                nodeLabelToMove.zPosition = zPosUpdater + 1
                zPosUpdater = zPosUpdater + 2
            }
        }
    }
    
    // Function runs on dragging screen touch
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-drag functionality here
        if nodeToMove != nil {
            for touch in touches {
                let location = touch.location(in: self)
                nodeToMove.position = CGPoint(x: nodeToMove.position.x + location.x - locationOld.x, y: nodeToMove.position.y + location.y - locationOld.y)
                nodeLabelToMove.position = CGPoint(x: nodeLabelToMove.position.x + location.x - locationOld.x, y: nodeLabelToMove.position.y + location.y - locationOld.y)
                locationOld = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        locationOld = nil
        nodeToMove = nil
        nodeLabelToMove = nil
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
        // Establish draggable tiles in bulk
        // Dimentional variables
        let tileMin = bottomMargin + midMargin + (0.6 * circleWidth)
        let tileMax = screenHeight / 2
        let tileOffsetX = tileLength / -2
        let tileBufferX = screenWidth / 6
        // Create tile
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
        // Assign tile type
        tile1.name = "tile"
        tile2.name = "tile"
        tile3.name = "tile"
        tile4.name = "tile"
        tile5.name = "tile"
        tile6.name = "tile"
        tile7.name = "tile"
        tile8.name = "tile"
        tile9.name = "tile"
        tile10.name = "tile"
        tile11.name = "tile"
        tile12.name = "tile"
        tile13.name = "tile"
        tile14.name = "tile"
        tile15.name = "tile"
        // Color tile
        tile1.fillColor = SKColor.white
        tile2.fillColor = SKColor.white
        tile3.fillColor = SKColor.white
        tile4.fillColor = SKColor.white
        tile5.fillColor = SKColor.white
        tile6.fillColor = SKColor.white
        tile7.fillColor = SKColor.white
        tile8.fillColor = SKColor.white
        tile9.fillColor = SKColor.white
        tile10.fillColor = SKColor.white
        tile11.fillColor = SKColor.white
        tile12.fillColor = SKColor.white
        tile13.fillColor = SKColor.white
        tile14.fillColor = SKColor.white
        tile15.fillColor = SKColor.white
        // Color outline tile
        tile1.strokeColor = SKColor.black
        tile2.strokeColor = SKColor.black
        tile3.strokeColor = SKColor.black
        tile4.strokeColor = SKColor.black
        tile5.strokeColor = SKColor.black
        tile6.strokeColor = SKColor.black
        tile7.strokeColor = SKColor.black
        tile8.strokeColor = SKColor.black
        tile9.strokeColor = SKColor.black
        tile10.strokeColor = SKColor.black
        tile11.strokeColor = SKColor.black
        tile12.strokeColor = SKColor.black
        tile13.strokeColor = SKColor.black
        tile14.strokeColor = SKColor.black
        tile15.strokeColor = SKColor.black
        // make tile always visable
        tile1.zPosition = 5
        tile2.zPosition = 5
        tile3.zPosition = 5
        tile4.zPosition = 5
        tile5.zPosition = 5
        tile6.zPosition = 5
        tile7.zPosition = 5
        tile8.zPosition = 5
        tile9.zPosition = 5
        tile10.zPosition = 5
        tile11.zPosition = 5
        tile12.zPosition = 5
        tile13.zPosition = 5
        tile14.zPosition = 5
        tile15.zPosition = 5
        // Create labels
        tileLabel1 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel2 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel3 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel4 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel5 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel6 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel7 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel8 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel9 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel10 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel11 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel12 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel13 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel14 = SKLabelNode(fontNamed: "ArialMT")
        tileLabel15 = SKLabelNode(fontNamed: "ArialMT")
        // Placeholder labels
        tileLabel1.text = "Cooling temps"
        tileLabel2.text = "Warming temps"
        tileLabel3.text = "Daily changes"
        tileLabel4.text = "Yearly changes"
        tileLabel5.text = ">30 year changes"
        tileLabel6.text = "Farming"
        tileLabel7.text = "Industry"
        tileLabel8.text = "Local"
        tileLabel9.text = "Regional"
        tileLabel10.text = "Global"
        tileLabel11.text = "Animals & plants"
        tileLabel12.text = "People"
        tileLabel13.text = "Forests"
        tileLabel14.text = "Oceans"
        tileLabel15.text = "Greenhouse effect"
        tileLabel1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel3.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel4.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel5.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel6.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel7.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel8.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel9.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel10.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel11.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel12.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel13.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel14.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel15.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tileLabel1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel5.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel6.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel7.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel8.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel9.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel10.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel11.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel12.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel13.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel14.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tileLabel15.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        if #available(iOS 11.0, *) {
            tileLabel1.numberOfLines = 3
            tileLabel1.preferredMaxLayoutWidth = tileLength
            tileLabel1.fontSize = tileLength / 6
            tileLabel2.numberOfLines = 3
            tileLabel2.preferredMaxLayoutWidth = tileLength
            tileLabel2.fontSize = tileLength / 6
            tileLabel3.numberOfLines = 3
            tileLabel3.preferredMaxLayoutWidth = tileLength
            tileLabel3.fontSize = tileLength / 6
            tileLabel4.numberOfLines = 3
            tileLabel4.preferredMaxLayoutWidth = tileLength
            tileLabel4.fontSize = tileLength / 6
            tileLabel5.numberOfLines = 3
            tileLabel5.preferredMaxLayoutWidth = tileLength
            tileLabel5.fontSize = tileLength / 6
            tileLabel6.numberOfLines = 3
            tileLabel6.preferredMaxLayoutWidth = tileLength
            tileLabel6.fontSize = tileLength / 6
            tileLabel7.numberOfLines = 3
            tileLabel7.preferredMaxLayoutWidth = tileLength
            tileLabel7.fontSize = tileLength / 6
            tileLabel8.numberOfLines = 3
            tileLabel8.preferredMaxLayoutWidth = tileLength
            tileLabel8.fontSize = tileLength / 6
            tileLabel9.numberOfLines = 3
            tileLabel9.preferredMaxLayoutWidth = tileLength
            tileLabel9.fontSize = tileLength / 6
            tileLabel10.numberOfLines = 3
            tileLabel10.preferredMaxLayoutWidth = tileLength
            tileLabel10.fontSize = tileLength / 6
            tileLabel11.numberOfLines = 3
            tileLabel11.preferredMaxLayoutWidth = tileLength
            tileLabel11.fontSize = tileLength / 6
            tileLabel12.numberOfLines = 3
            tileLabel12.preferredMaxLayoutWidth = tileLength
            tileLabel12.fontSize = tileLength / 6
            tileLabel13.numberOfLines = 3
            tileLabel13.preferredMaxLayoutWidth = tileLength
            tileLabel13.fontSize = tileLength / 6
            tileLabel14.numberOfLines = 3
            tileLabel14.preferredMaxLayoutWidth = tileLength
            tileLabel14.fontSize = tileLength / 6
            tileLabel15.numberOfLines = 3
            tileLabel15.preferredMaxLayoutWidth = tileLength
            tileLabel15.fontSize = tileLength / 6
        } else {
            // Fallback on earlier versions
            // FIX IN FUTURE UPDATE
        }
        // add tiles to screen
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
        // Place Labels in center of tiles
        tileLabel1.position = CGPoint(x: tile1.frame.minX + (tileLength / 20), y: tile1.frame.midY)
        tileLabel2.position = CGPoint(x: tile2.frame.minX + (tileLength / 20), y: tile2.frame.midY)
        tileLabel3.position = CGPoint(x: tile3.frame.minX + (tileLength / 20), y: tile3.frame.midY)
        tileLabel4.position = CGPoint(x: tile4.frame.minX + (tileLength / 20), y: tile4.frame.midY)
        tileLabel5.position = CGPoint(x: tile5.frame.minX + (tileLength / 20), y: tile5.frame.midY)
        tileLabel6.position = CGPoint(x: tile6.frame.minX + (tileLength / 20), y: tile6.frame.midY)
        tileLabel7.position = CGPoint(x: tile7.frame.minX + (tileLength / 20), y: tile7.frame.midY)
        tileLabel8.position = CGPoint(x: tile8.frame.minX + (tileLength / 20), y: tile8.frame.midY)
        tileLabel9.position = CGPoint(x: tile9.frame.minX + (tileLength / 20), y: tile9.frame.midY)
        tileLabel10.position = CGPoint(x: tile10.frame.minX + (tileLength / 20), y: tile10.frame.midY)
        tileLabel11.position = CGPoint(x: tile11.frame.minX + (tileLength / 20), y: tile11.frame.midY)
        tileLabel12.position = CGPoint(x: tile12.frame.minX + (tileLength / 20), y: tile12.frame.midY)
        tileLabel13.position = CGPoint(x: tile13.frame.minX + (tileLength / 20), y: tile13.frame.midY)
        tileLabel14.position = CGPoint(x: tile14.frame.minX + (tileLength / 20), y: tile14.frame.midY)
        tileLabel15.position = CGPoint(x: tile15.frame.minX + (tileLength / 20), y: tile15.frame.midY)
        // Color text
        tileLabel1.fontColor = SKColor.black
        tileLabel2.fontColor = SKColor.black
        tileLabel3.fontColor = SKColor.black
        tileLabel4.fontColor = SKColor.black
        tileLabel5.fontColor = SKColor.black
        tileLabel6.fontColor = SKColor.black
        tileLabel7.fontColor = SKColor.black
        tileLabel8.fontColor = SKColor.black
        tileLabel9.fontColor = SKColor.black
        tileLabel10.fontColor = SKColor.black
        tileLabel11.fontColor = SKColor.black
        tileLabel12.fontColor = SKColor.black
        tileLabel13.fontColor = SKColor.black
        tileLabel14.fontColor = SKColor.black
        tileLabel15.fontColor = SKColor.black
        // Make labels appear over tiles
        tileLabel1.zPosition = 6
        tileLabel2.zPosition = 6
        tileLabel3.zPosition = 6
        tileLabel4.zPosition = 6
        tileLabel5.zPosition = 6
        tileLabel6.zPosition = 6
        tileLabel7.zPosition = 6
        tileLabel8.zPosition = 6
        tileLabel9.zPosition = 6
        tileLabel10.zPosition = 6
        tileLabel11.zPosition = 6
        tileLabel12.zPosition = 6
        tileLabel13.zPosition = 6
        tileLabel14.zPosition = 6
        tileLabel15.zPosition = 6
        // Add labels  to screen
        self.addChild(tileLabel1)
        self.addChild(tileLabel2)
        self.addChild(tileLabel3)
        self.addChild(tileLabel4)
        self.addChild(tileLabel5)
        self.addChild(tileLabel6)
        self.addChild(tileLabel7)
        self.addChild(tileLabel8)
        self.addChild(tileLabel9)
        self.addChild(tileLabel10)
        self.addChild(tileLabel11)
        self.addChild(tileLabel12)
        self.addChild(tileLabel13)
        self.addChild(tileLabel14)
        self.addChild(tileLabel15)
    }
}
