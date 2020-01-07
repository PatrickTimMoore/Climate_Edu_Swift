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
    //declaring varables used between initialization and in-game data
    var game: GameManager!
    var climateBG: SKShapeNode!
    var weatherBG: SKShapeNode!
    var enviromBG: SKShapeNode!
    var cwBG: SKShapeNode!
    var weBG: SKShapeNode!
    var ceBG: SKShapeNode!
    var cweBG: SKShapeNode!
    var naBG: SKShapeNode!
    var ceBar: [CGPoint]!
    var weBar: [CGPoint]!
    var p1: CGPoint!
    var p2: CGPoint!
    var p3: CGPoint!
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
    var submit: SKShapeNode!
    var nodeToMove: SKNode!
    var locationOld: CGPoint!
    var zPosUpdater: CGFloat!
    var nodeFound: Bool!
    var makeSumbitVis: Bool = false
    var circleWidth: CGFloat!
    var bottomMargin: CGFloat!
    var midMargin: CGFloat!
    var tileBankLocDict: Dictionary<Int, CGPoint>!
    var remainingInBank: Int = 15
    var dictLookup: Int!
    
    // Function runs on start of the aplication
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager(scene: self)
        zPosUpdater = 8
    }
    
    // Function runs on initial screen touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-click functionality here
        for touch in touches {
            let location = touch.location(in: self)
            // Prints touch location (x, y)
            print(location)
            // Creates list of nodes sorted by Z-value at touch location
            let touchedNode = self.nodes(at: location)
            // Checks for first 'tile' node
            for node in touchedNode {
                if node.name == "tile" && !node.hasActions(){
                    nodeToMove = node
                    locationOld = location
                    break
                }
            }
            // Resets node to be of regular angle if not
            if nodeToMove != nil {
                let castedNode:SKShapeNode = nodeToMove as! SKShapeNode
                if castedNode.fillColor == SKColor(red: 1/2, green: 1, blue: 1, alpha: 1) {
                    nodeToMove.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
                }
                if castedNode.fillColor == SKColor(red: 1, green: 1, blue: 1/2, alpha: 1) {
                    nodeToMove.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
                }
            }
            // Checks if a tile node is found
            if nodeToMove != nil {
                // Updates z Position so that selected nodes always appear on top
                nodeToMove.zPosition = zPosUpdater
                zPosUpdater = zPosUpdater + 2
                // Increases size of selected tile
                nodeToMove.run(SKAction.scale(to: 1.4, duration: 0.2))
                // Searches for underlying zone
                nodeFound = false
                for node in touchedNode {
                    if node.name == "c_space" || node.name == "w_space" || node.name == "e_space" {
                        if (node.name == "c_space") && (distance(location, p1) < circleWidth / 2) {
                            // Prints underlying location
                            print("C Circle Pick!")
                            nodeFound = true
                            break
                        } else if (node.name == "w_space") && (distance(location, p2) < circleWidth / 2) {
                            // Prints underlying location
                            print("W Circle Pick!")
                            nodeFound = true
                            break
                        } else if (node.name == "e_space") && (distance(location, p3) < circleWidth / 2) {
                            // Prints underlying location
                            print("E Circle Pick!")
                            nodeFound = true
                            break
                        }
                    } else if node.name == "cwe_space" && (location.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) {
                        // Prints underlying location
                        print("CWE Triangle Pick!")
                        nodeFound = true
                        break
                    } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                        if node.name == "cw_space" {
                            // Prints underlying location
                            print("CW Bar Pick!")
                            nodeFound = true
                            break
                        } else if node.name == "we_space" && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) && (location.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (location.x - weBar[3].x) + weBar[3].y)) {
                            // Prints underlying location
                            print("WE Bar Pick!")
                            nodeFound = true
                            break
                        } else if node.name == "ce_space" && (location.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (location.x - ceBar[3].x) + ceBar[3].y)) && (location.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) {
                            // Prints underlying location
                            print("CE Bar Pick!")
                            nodeFound = true
                            break
                        }
                    } else if node.name == "na_space" {
                        // Prints underlying location
                        print("None Pick!")
                        nodeFound = true
                        break
                    }
                }
                if !nodeFound{
                    // Prints underlying location
                    print("Bank pick!")
                    // Updates the count in the Bank
                    remainingInBank = remainingInBank - 1
                    // Displays submit option if Bank is empty
                    if remainingInBank == 0 {
                        makeSumbitVis = true
                        submit.zPosition = zPosUpdater
                        zPosUpdater = zPosUpdater + 2
                    }
                    // Prints remaining bank count
                    print(remainingInBank)
                }
            }
        }
    }
    
    // Function runs on dragging screen touch
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-drag functionality here
        // Checks if a node is currently selected
        if nodeToMove != nil {
            // Break statements stop from multi-touch
            for touch in touches {
                // Finds selected tile and updates position
                let location = touch.location(in: self)
                nodeToMove.position = CGPoint(x: nodeToMove.position.x + location.x - locationOld.x, y: nodeToMove.position.y + location.y - locationOld.y)
                locationOld = location
                let castedNode:SKShapeNode = nodeToMove as! SKShapeNode
                let touchedNodeMid = self.nodes(at: location)
                // The following updates the tile color!
                for node in touchedNodeMid {
                    if node.name == "c_space" || node.name == "w_space" || node.name == "e_space" {
                        if (node.name == "c_space") && (distance(location, p1) < circleWidth / 2) {
                            castedNode.fillColor = SKColor(red: 1/2, green: 1/2, blue: 1, alpha: 1)
                            break
                        } else if (node.name == "w_space") && (distance(location, p2) < circleWidth / 2) {
                            castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1/2, alpha: 1)
                            break
                        } else if (node.name == "e_space") && (distance(location, p3) < circleWidth / 2) {
                            castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1/2, alpha: 1)
                            break
                        }
                    } else if node.name == "cwe_space" && (location.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) {
                        castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                        break
                    } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                        if node.name == "cw_space" {
                            castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1, alpha: 1)
                            break
                        } else if node.name == "we_space" && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) && (location.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (location.x - weBar[3].x) + weBar[3].y)) {
                            castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1/2, alpha: 1)
                            break
                        } else if node.name == "ce_space" && (location.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (location.x - ceBar[3].x) + ceBar[3].y)) && (location.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) {
                            castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1, alpha: 1)
                            break
                        }
                    } else if node.name == "na_space" {
                        castedNode.fillColor = SKColor(red: 5/6, green: 5/6, blue: 5/6, alpha: 1)
                        break
                    } else {
                        castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                    }
                }
            }
        }
    }
    
    // This function is used to determine distance between two CGPoints
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    // Runs upon touch release
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-release functionality here
        if nodeToMove != nil {
            let castedNode:SKShapeNode = nodeToMove as! SKShapeNode
            // Finds locaion of selected tile
            for touch in touches {
                let locationEnd = touch.location(in: self)
                let touchedNodeEnd = self.nodes(at: locationEnd)
                nodeFound = false
                for node in touchedNodeEnd {
                    // Performs the resizing, recoloring, and reangling!
                    if node.name == "c_space" || node.name == "w_space" || node.name == "e_space" {
                        if (node.name == "c_space") && (distance(locationEnd, p1) < circleWidth / 2) {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1/2, green: 1/2, blue: 1, alpha: 1)
                            print("C Circle!")
                            nodeFound = true
                            break
                        } else if (node.name == "w_space") && (distance(locationEnd, p2) < circleWidth / 2) {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1/2, alpha: 1)
                            print("W Circle!")
                            nodeFound = true
                            break
                        } else if (node.name == "e_space") && (distance(locationEnd, p3) < circleWidth / 2) {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1/2, alpha: 1)
                            print("E Circle!")
                            nodeFound = true
                            break
                        }
                    } else if node.name == "cwe_space" && (locationEnd.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) {
                        // Prints underlying location
                        nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                        castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                        print("CWE Triangle!")
                        nodeFound = true
                        break
                    } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                        if node.name == "cw_space" {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1, alpha: 1)
                            print("CW Bar!")
                            nodeFound = true
                            break
                        } else if node.name == "we_space" && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) && (locationEnd.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (locationEnd.x - weBar[3].x) + weBar[3].y)) {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                            nodeToMove.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1/2, alpha: 1)
                            print("WE Bar!")
                            nodeFound = true
                            break
                        } else if node.name == "ce_space" && (locationEnd.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (locationEnd.x - ceBar[3].x) + ceBar[3].y)) && (locationEnd.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                            nodeToMove.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1, alpha: 1)
                            print("CE Bar!")
                            nodeFound = true
                            break
                        }
                    } else if node.name == "na_space" {
                        // Prints underlying location
                        nodeToMove.run(SKAction.scale(to: 0.6, duration: 0.2))
                        castedNode.fillColor = SKColor(red: 5/6, green: 5/6, blue: 5/6, alpha: 1)
                        print("None!")
                        nodeFound = true
                        break
                    }
                }
                // Finds dictionary entry for the bank location
                if !nodeFound {
                    switch nodeToMove {
                    case tile1:
                        dictLookup = 1
                        break
                    case tile2:
                        dictLookup = 2
                        break
                    case tile3:
                        dictLookup = 3
                        break
                    case tile4:
                        dictLookup = 4
                        break
                    case tile5:
                        dictLookup = 5
                        break
                    case tile6:
                        dictLookup = 6
                        break
                    case tile7:
                        dictLookup = 7
                        break
                    case tile8:
                        dictLookup = 8
                        break
                    case tile9:
                        dictLookup = 9
                        break
                    case tile10:
                        dictLookup = 10
                        break
                    case tile11:
                        dictLookup = 11
                        break
                    case tile12:
                        dictLookup = 12
                        break
                    case tile13:
                        dictLookup = 13
                        break
                    case tile14:
                        dictLookup = 14
                        break
                    case tile15:
                        dictLookup = 15
                        break
                    case .none:
                        dictLookup = 1
                        break
                    case .some(_):
                        dictLookup = 1
                        break
                    }
                    // Returns tile to it's proper bank location
                    nodeToMove.run(SKAction.move(by: CGVector(dx: tileBankLocDict[dictLookup]!.x - (nodeToMove.position.x), dy: tileBankLocDict[dictLookup]!.y - (nodeToMove.position.y)), duration: 0.3))
                    castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                    // Returns tile to normal side
                    nodeToMove.run(SKAction.scale(to: 1, duration: 0.2))
                    // Updates bank count
                    remainingInBank = remainingInBank + 1
                    // Hides submit if submit is a tile is selected
                    submit.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                    print(remainingInBank)
                    print("Bank!")
                }
            }
            // Displays submit if bank is empty
            if makeSumbitVis && remainingInBank == 0 {
                submit.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                makeSumbitVis = false
            }
            locationOld = nil
            nodeToMove = nil
        }
    }
    
    private func initializeMenu() {
        // Declaring constants to determine object sizing
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        // Determines ratio
        let ratio: CGFloat = (screenWidth / CGFloat(850))
        circleWidth = (ratio * CGFloat(270))
        let barWidth: CGFloat = ratio * 110
        let barLength: CGFloat = ratio * CGFloat(550)
        bottomMargin = ((screenHeight / -2) + (0.6 * circleWidth))
        midMargin = ((3 / 4) * barLength * barLength).squareRoot()
        // Declares size of tiles
        let tileLengthOriginal: CGFloat = ((1/9) * 850 * ratio)
        let tileHeight: CGFloat = (tileLengthOriginal / 2)
        let tileLength = tileLengthOriginal + tileHeight
        // Declares center of the 3 circles as anchor points
        p1 = CGPoint(x: (barLength / -2), y: bottomMargin + midMargin)
        p2 = CGPoint(x: (barLength / 2), y: bottomMargin + midMargin)
        p3 = CGPoint(x: 0, y: bottomMargin)
        // Create N/A Area
        naBG = SKShapeNode()
        naBG.position = CGPoint(x: 0, y: 0)
        naBG.zPosition = 1
        let path5 = CGMutablePath()
        let halfScreenWidth = (screenWidth / 2)
        let naSpace: [CGPoint] = [CGPoint(x: -(halfScreenWidth) - (4 * ratio), y: midMargin + bottomMargin + (0.6 * circleWidth)), CGPoint(x: -(halfScreenWidth) - (4 * ratio), y: (screenHeight / -2) - (4 * ratio)), CGPoint(x: halfScreenWidth + (4 * ratio), y: (screenHeight / -2) - (4 * ratio)), CGPoint(x: halfScreenWidth + (4 * ratio), y: midMargin + bottomMargin + (0.6 * circleWidth))]
        path5.addLines(between: [naSpace[0], naSpace[1], naSpace[2], naSpace[3], naSpace[0]])
        naBG.path = path5
        naBG.fillColor = SKColor.lightGray
        naBG.strokeColor = SKColor.black
        naBG.lineWidth = 4 * ratio
        naBG.name = "na_space"
        self.addChild(naBG)
        // Create Common Area
        cweBG = SKShapeNode()
        cweBG.position = CGPoint(x: 0, y: 0)
        cweBG.zPosition = 2
        let path1 = CGMutablePath()
        path1.addLines(between: [p1, p2, p3])
        cweBG.path = path1
        cweBG.fillColor = SKColor.white
        cweBG.name = "cwe_space"
        self.addChild(cweBG)
        // Create Combo Area
        cwBG = SKShapeNode()
        cwBG.position = CGPoint(x: 0, y: 0)
        cwBG.zPosition = 3
        let path2 = CGMutablePath()
        let cwBar = [CGPoint(x: p1.x, y: p1.y + (barWidth / 2)), CGPoint(x: p2.x, y: p2.y + (barWidth / 2)), CGPoint(x: p2.x, y: p2.y - (barWidth / 2)), CGPoint(x: p1.x, y: p1.y - (barWidth / 2))]
        path2.addLines(between: [cwBar[0], cwBar[1], cwBar[2], cwBar[3], cwBar[0]])
        cwBG.path = path2
        cwBG.fillColor = SKColor.magenta
        cwBG.strokeColor = SKColor.black
        cwBG.lineWidth = 4 * ratio
        cwBG.name = "cw_space"
        self.addChild(cwBG)
        // Create Combo Area
        ceBG = SKShapeNode()
        ceBG.position = CGPoint(x: 0, y: 0)
        ceBG.zPosition = 3
        let path3 = CGMutablePath()
        ceBar = [CGPoint(x: p1.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p1.y + (barWidth / 4)), CGPoint(x: p3.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y + (barWidth / 4)), CGPoint(x: p3.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y - (barWidth / 4)), CGPoint(x: p1.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p1.y - (barWidth / 4))]
        path3.addLines(between: [ceBar[0], ceBar[1], ceBar[2], ceBar[3], ceBar[0]])
        ceBG.path = path3
        ceBG.fillColor = SKColor.cyan
        ceBG.strokeColor = SKColor.black
        ceBG.lineWidth = 4 * ratio
        ceBG.name = "ce_space"
        self.addChild(ceBG)
        // Create Combo Area
        weBG = SKShapeNode()
        weBG.position = CGPoint(x: 0, y: 0)
        weBG.zPosition = 3
        let path4 = CGMutablePath()
        weBar = [CGPoint(x: p3.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y - (barWidth / 4)), CGPoint(x: p2.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p2.y - (barWidth / 4)), CGPoint(x: p2.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p2.y + (barWidth / 4)), CGPoint(x: p3.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y + (barWidth / 4))]
        path4.addLines(between: [weBar[0], weBar[1], weBar[2], weBar[3], weBar[0]])
        weBG.path = path4
        weBG.fillColor = SKColor.yellow
        weBG.strokeColor = SKColor.black
        weBG.lineWidth = 4 * ratio
        weBG.name = "we_space"
        self.addChild(weBG)
        // Create Climate Circle
        climateBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        climateBG.position = p1
        climateBG.zPosition = 4
        climateBG.fillColor = SKColor.blue
        climateBG.strokeColor = SKColor.black
        climateBG.lineWidth = 4 * ratio
        climateBG.name = "c_space"
        self.addChild(climateBG)
        // Create Weather Circle
        weatherBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        weatherBG.position = p2
        weatherBG.zPosition = 4
        weatherBG.fillColor = SKColor.red
        weatherBG.strokeColor = SKColor.black
        weatherBG.lineWidth = 4 * ratio
        weatherBG.name = "w_space"
        self.addChild(weatherBG)
        // Create Enviroment Circle
        enviromBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        enviromBG.position = p3
        enviromBG.zPosition = 4
        enviromBG.fillColor = SKColor.green
        enviromBG.strokeColor = SKColor.black
        enviromBG.lineWidth = 4 * ratio
        enviromBG.name = "e_space"
        self.addChild(enviromBG)
        // Create Immobile Bank Label
        let bankLabel = SKLabelNode(fontNamed: "ArialMT")
        bankLabel.text = "Word Bank"
        bankLabel.fontSize = 50 * ratio
        bankLabel.zPosition = 2
        bankLabel.position = CGPoint(x: naBG.frame.midX, y: naBG.frame.maxY + (25 * ratio))
        bankLabel.fontColor = SKColor.black
        self.addChild(bankLabel)
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
        cLabel.zPosition = 5
        wLabel.zPosition = 5
        eLabel.zPosition = 5
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
        cwLabel1.zPosition = 5
        cwLabel2.zPosition = 5
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
        ceLabel1.zPosition = 5
        ceLabel2.zPosition = 5
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
        weLabel1.zPosition = 5
        weLabel2.zPosition = 5
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
        cweLabel1.zPosition = 5
        cweLabel2.zPosition = 5
        cweLabel3.zPosition = 5
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
        naLabel1.zPosition = 5
        naLabel2.zPosition = 5
        naLabel3.zPosition = 5
        naLabel4.zPosition = 5
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
        let tileBufferX = screenWidth / 5.2
        // Create tile lookup table
        let origin1 = CGPoint(x: tileOffsetX - (2 * tileBufferX) + (tileLength / 2), y: (tileMin / 4) + (3 * tileMax / 4) + (tileHeight / 2))
        let origin2 = CGPoint(x: tileOffsetX - tileBufferX + (tileLength / 2), y: (tileMin / 4) + (3 * tileMax / 4) + (tileHeight / 2))
        let origin3 = CGPoint(x: tileOffsetX + (tileLength / 2), y: (tileMin / 4) + (3 * tileMax / 4) + (tileHeight / 2))
        let origin4 = CGPoint(x: tileOffsetX + tileBufferX + (tileLength / 2), y: (tileMin / 4) + (3 * tileMax / 4) + (tileHeight / 2))
        let origin5 = CGPoint(x: tileOffsetX + (2 * tileBufferX) + (tileLength / 2), y: (tileMin / 4) + (3 * tileMax / 4) + (tileHeight / 2))
        let origin6 = CGPoint(x: tileOffsetX - (2 * tileBufferX) + (tileLength / 2), y: (tileMin + tileMax) / 2 + (tileHeight / 2))
        let origin7 = CGPoint(x: tileOffsetX - tileBufferX + (tileLength / 2), y: (tileMin + tileMax) / 2 + (tileHeight / 2))
        let origin8 = CGPoint(x: tileOffsetX + (tileLength / 2), y: (tileMin + tileMax) / 2 + (tileHeight / 2))
        let origin9 = CGPoint(x: tileOffsetX + tileBufferX + (tileLength / 2), y: (tileMin + tileMax) / 2 + (tileHeight / 2))
        let origin10 = CGPoint(x: tileOffsetX + (2 * tileBufferX) + (tileLength / 2), y: (tileMin + tileMax) / 2 + (tileHeight / 2))
        let origin11 = CGPoint(x: tileOffsetX - (2 * tileBufferX) + (tileLength / 2), y: (3 * tileMin / 4) + (tileMax / 4) + (tileHeight / 2))
        let origin12 = CGPoint(x: tileOffsetX - tileBufferX + (tileLength / 2), y: (3 * tileMin / 4) + (tileMax / 4) + (tileHeight / 2))
        let origin13 = CGPoint(x: tileOffsetX + (tileLength / 2), y: (3 * tileMin / 4) + (tileMax / 4) + (tileHeight / 2))
        let origin14 = CGPoint(x: tileOffsetX + tileBufferX + (tileLength / 2), y: (3 * tileMin / 4) + (tileMax / 4) + (tileHeight / 2))
        let origin15 = CGPoint(x: tileOffsetX + (2 * tileBufferX) + (tileLength / 2), y: (3 * tileMin / 4) + (tileMax / 4) + (tileHeight / 2))
        // Creates dictionary to relate positions
        tileBankLocDict = [1: origin1,
                           2: origin2,
                           3: origin3,
                           4: origin4,
                           5: origin5,
                           6: origin6,
                           7: origin7,
                           8: origin8,
                           9: origin9,
                           10: origin10,
                           11: origin11,
                           12: origin12,
                           13: origin13,
                           14: origin14,
                           15: origin15]
        // Creates tiles to be used
        tile1 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile1.position = tileBankLocDict[1]!
        tile2 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile2.position = tileBankLocDict[2]!
        tile3 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile3.position = tileBankLocDict[3]!
        tile4 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile4.position = tileBankLocDict[4]!
        tile5 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile5.position = tileBankLocDict[5]!
        tile6 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile6.position = tileBankLocDict[6]!
        tile7 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile7.position = tileBankLocDict[7]!
        tile8 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile8.position = tileBankLocDict[8]!
        tile9 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile9.position = tileBankLocDict[9]!
        tile10 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile10.position = tileBankLocDict[10]!
        tile11 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile11.position = tileBankLocDict[11]!
        tile12 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile12.position = tileBankLocDict[12]!
        tile13 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile13.position = tileBankLocDict[13]!
        tile14 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile14.position = tileBankLocDict[14]!
        tile15 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile15.position = tileBankLocDict[15]!
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
        // Size outline tile
        tile1.lineWidth = 2 * ratio
        tile2.lineWidth = 2 * ratio
        tile3.lineWidth = 2 * ratio
        tile4.lineWidth = 2 * ratio
        tile5.lineWidth = 2 * ratio
        tile6.lineWidth = 2 * ratio
        tile7.lineWidth = 2 * ratio
        tile8.lineWidth = 2 * ratio
        tile9.lineWidth = 2 * ratio
        tile10.lineWidth = 2 * ratio
        tile11.lineWidth = 2 * ratio
        tile12.lineWidth = 2 * ratio
        tile13.lineWidth = 2 * ratio
        tile14.lineWidth = 2 * ratio
        tile15.lineWidth = 2 * ratio
        // make tile always visable lineWidth
        tile1.zPosition = 6
        tile2.zPosition = 6
        tile3.zPosition = 6
        tile4.zPosition = 6
        tile5.zPosition = 6
        tile6.zPosition = 6
        tile7.zPosition = 6
        tile8.zPosition = 6
        tile9.zPosition = 6
        tile10.zPosition = 6
        tile11.zPosition = 6
        tile12.zPosition = 6
        tile13.zPosition = 6
        tile14.zPosition = 6
        tile15.zPosition = 6
        // Create labels
        let tileLabel1 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel2 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel3 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel4 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel5 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel6 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel7 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel8 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel9 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel10 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel11 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel12 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel13 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel14 = SKLabelNode(fontNamed: "ArialMT")
        let tileLabel15 = SKLabelNode(fontNamed: "ArialMT")
        // Labels and associated position
        tileLabel1.text = "Cooling\n temps "
        tileLabel2.text = "Warming\n  temps "
        tileLabel3.text = "   Daily\nchanges"
        tileLabel4.text = "  Yearly\nchanges"
        tileLabel5.text = ">30 year\n changes "
        tileLabel6.text = "Farming"
        tileLabel7.text = "Industry"
        tileLabel8.text = "Local"
        tileLabel9.text = "Regional"
        tileLabel10.text = "Global"
        tileLabel11.text = "Animals\n& plants"
        tileLabel12.text = "People"
        tileLabel13.text = "Forests"
        tileLabel14.text = "Oceans"
        tileLabel15.text = "Greenhouse\n      effect "
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
        tileLabel1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel5.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel6.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel7.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel8.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel9.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel10.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel11.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel12.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel13.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel14.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tileLabel15.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        if #available(iOS 11.0, *) {
            // OLD iOS code just incase (^_~)
            tileLabel1.numberOfLines = 3
            tileLabel1.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel1.fontSize = tileLengthOriginal / 6
            tileLabel2.numberOfLines = 3
            tileLabel2.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel2.fontSize = tileLengthOriginal / 6
            tileLabel3.numberOfLines = 3
            tileLabel3.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel3.fontSize = tileLengthOriginal / 6
            tileLabel4.numberOfLines = 3
            tileLabel4.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel4.fontSize = tileLengthOriginal / 6
            tileLabel5.numberOfLines = 3
            tileLabel5.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel5.fontSize = tileLengthOriginal / 6
            tileLabel6.numberOfLines = 3
            tileLabel6.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel6.fontSize = tileLengthOriginal / 6
            tileLabel7.numberOfLines = 3
            tileLabel7.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel7.fontSize = tileLengthOriginal / 6
            tileLabel8.numberOfLines = 3
            tileLabel8.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel8.fontSize = tileLengthOriginal / 6
            tileLabel9.numberOfLines = 3
            tileLabel9.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel9.fontSize = tileLengthOriginal / 6
            tileLabel10.numberOfLines = 3
            tileLabel10.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel10.fontSize = tileLengthOriginal / 6
            tileLabel11.numberOfLines = 3
            tileLabel11.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel11.fontSize = tileLengthOriginal / 6
            tileLabel12.numberOfLines = 3
            tileLabel12.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel12.fontSize = tileLengthOriginal / 6
            tileLabel13.numberOfLines = 3
            tileLabel13.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel13.fontSize = tileLengthOriginal / 6
            tileLabel14.numberOfLines = 3
            tileLabel14.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel14.fontSize = tileLengthOriginal / 6
            tileLabel15.numberOfLines = 3
            tileLabel15.preferredMaxLayoutWidth = tileLengthOriginal
            tileLabel15.fontSize = tileLengthOriginal / 6
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
        tileLabel1.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel2.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel3.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel4.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel5.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel6.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel7.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel8.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel9.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel10.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel11.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel12.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel13.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel14.position = CGPoint(x: (tileHeight / 2), y: 0)
        tileLabel15.position = CGPoint(x: (tileHeight / 2), y: 0)
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
        tileLabel1.zPosition = 1
        tileLabel2.zPosition = 1
        tileLabel3.zPosition = 1
        tileLabel4.zPosition = 1
        tileLabel5.zPosition = 1
        tileLabel6.zPosition = 1
        tileLabel7.zPosition = 1
        tileLabel8.zPosition = 1
        tileLabel9.zPosition = 1
        tileLabel10.zPosition = 1
        tileLabel11.zPosition = 1
        tileLabel12.zPosition = 1
        tileLabel13.zPosition = 1
        tileLabel14.zPosition = 1
        tileLabel15.zPosition = 1
        // Add labels  to screen
        tile1.addChild(tileLabel1)
        tile2.addChild(tileLabel2)
        tile3.addChild(tileLabel3)
        tile4.addChild(tileLabel4)
        tile5.addChild(tileLabel5)
        tile6.addChild(tileLabel6)
        tile7.addChild(tileLabel7)
        tile8.addChild(tileLabel8)
        tile9.addChild(tileLabel9)
        tile10.addChild(tileLabel10)
        tile11.addChild(tileLabel11)
        tile12.addChild(tileLabel12)
        tile13.addChild(tileLabel13)
        tile14.addChild(tileLabel14)
        tile15.addChild(tileLabel15)
        // Create Sprite constants
        let spriteOffset = (((tileHeight - (2 * ratio)) - tile1.frame.width) / 2) + (3 * ratio)
        let spritePos = CGPoint(x: spriteOffset, y: 0)
        let spriteSize = CGSize(width: tileHeight - (2 * ratio), height: tileHeight - (2 * ratio))
        // Initialize sprites to images
        let tileSprite1 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite2 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite3 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite4 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite5 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite6 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite7 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite8 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite9 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite10 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite11 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite12 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite13 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite14 = SKSpriteNode(imageNamed: "SampleSprite")
        let tileSprite15 = SKSpriteNode(imageNamed: "SampleSprite")
        // Sets sprite size
        tileSprite1.size = spriteSize
        tileSprite2.size = spriteSize
        tileSprite3.size = spriteSize
        tileSprite4.size = spriteSize
        tileSprite5.size = spriteSize
        tileSprite6.size = spriteSize
        tileSprite7.size = spriteSize
        tileSprite8.size = spriteSize
        tileSprite9.size = spriteSize
        tileSprite10.size = spriteSize
        tileSprite11.size = spriteSize
        tileSprite12.size = spriteSize
        tileSprite13.size = spriteSize
        tileSprite14.size = spriteSize
        tileSprite15.size = spriteSize
        tileSprite1.position = spritePos
        tileSprite2.position = spritePos
        tileSprite3.position = spritePos
        tileSprite4.position = spritePos
        tileSprite5.position = spritePos
        tileSprite6.position = spritePos
        tileSprite7.position = spritePos
        tileSprite8.position = spritePos
        tileSprite9.position = spritePos
        tileSprite10.position = spritePos
        tileSprite11.position = spritePos
        tileSprite12.position = spritePos
        tileSprite13.position = spritePos
        tileSprite14.position = spritePos
        tileSprite15.position = spritePos
        // sets sprite on top of tile
        tileSprite1.zPosition = 1
        tileSprite2.zPosition = 1
        tileSprite3.zPosition = 1
        tileSprite4.zPosition = 1
        tileSprite5.zPosition = 1
        tileSprite6.zPosition = 1
        tileSprite7.zPosition = 1
        tileSprite8.zPosition = 1
        tileSprite9.zPosition = 1
        tileSprite10.zPosition = 1
        tileSprite11.zPosition = 1
        tileSprite12.zPosition = 1
        tileSprite13.zPosition = 1
        tileSprite14.zPosition = 1
        tileSprite15.zPosition = 1
        // Adds sprite to tile
        tile1.addChild(tileSprite1)
        tile2.addChild(tileSprite2)
        tile3.addChild(tileSprite3)
        tile4.addChild(tileSprite4)
        tile5.addChild(tileSprite5)
        tile6.addChild(tileSprite6)
        tile7.addChild(tileSprite7)
        tile8.addChild(tileSprite8)
        tile9.addChild(tileSprite9)
        tile10.addChild(tileSprite10)
        tile11.addChild(tileSprite11)
        tile12.addChild(tileSprite12)
        tile13.addChild(tileSprite13)
        tile14.addChild(tileSprite14)
        tile15.addChild(tileSprite15)
        // Submit button
        submit = SKShapeNode.init(ellipseOf: CGSize.init(width: screenWidth/3, height: screenWidth/10))
        submit.position = CGPoint(x: naBG.frame.midX, y: (naBG.frame.maxY + screenHeight/2)/2)
        submit.zPosition = -5
        submit.fillColor = SKColor.systemBlue
        submit.alpha = 0
        submit.strokeColor = SKColor.black
        self.addChild(submit)
        // Creates text to lay on button
        let submitLabel = SKLabelNode(fontNamed: "ArialMT")
        submitLabel.text = "SUBMIT"
        submitLabel.fontColor = SKColor.white
        submitLabel.zPosition = 1
        submitLabel.fontSize = 40 * ratio
        submitLabel.position = CGPoint(x: 0, y: -submitLabel.frame.height / 2)
        submit.addChild(submitLabel)
    }
}
