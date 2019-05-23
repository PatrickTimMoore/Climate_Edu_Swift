//
//  GameScene.swift
//  Snake
//
//  Created by Patrick Moore on 5/15/19.
//  Copyright © 2019 Patrick Moore. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //1
    var game: GameManager!
    var climateBG: SKShapeNode!
    var weatherBG: SKShapeNode!
    var enviromBG: SKShapeNode!
    var cwBG: SKShapeNode!
    var weBG: SKShapeNode!
    var ceBG: SKShapeNode!
    var cweBG: SKShapeNode!
    
    override func didMove(to view: SKView) {
        //2
        initializeMenu()
        game = GameManager(scene: self)
    }
    
    //3
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func initializeMenu() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let ratio: CGFloat = (screenWidth / CGFloat(850))
        let circleWidth: CGFloat = (ratio * CGFloat(270))
        let barWidth: CGFloat = ratio * 110
        let barLength: CGFloat = ratio * CGFloat(550)
        let bottomMargin: CGFloat = ((screenHeight / -2) + (0.6 * circleWidth))
        let midMargin: CGFloat = ((3 / 4) * barLength * barLength).squareRoot()
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
        cweBG.fillColor = SKColor.lightGray
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
        cwBG.fillColor = SKColor.purple
        cwBG.name = "cw_space"
        self.addChild(cwBG)
        // Create Combo Area
        weBG = SKShapeNode()
        weBG.position = CGPoint(x: 0, y: 0)
        weBG.zPosition = 2
        let path3 = CGMutablePath()
        let weBar: [CGPoint] = [CGPoint(x: p1.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p1.y + (barWidth / 4)), CGPoint(x: p3.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y + (barWidth / 4)), CGPoint(x: p3.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y - (barWidth / 4)), CGPoint(x: p1.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p1.y - (barWidth / 4))]
        path3.addLines(between: [weBar[0], weBar[1], weBar[2], weBar[3]])
        weBG.path = path3
        weBG.fillColor = SKColor.cyan
        weBG.name = "we_space"
        self.addChild(weBG)
        // Create Combo Area
        ceBG = SKShapeNode()
        ceBG.position = CGPoint(x: 0, y: 0)
        ceBG.zPosition = 2
        let path4 = CGMutablePath()
        let ceBar: [CGPoint] = [CGPoint(x: p3.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y - (barWidth / 4)), CGPoint(x: p2.x + ((barWidth * CGFloat(3.squareRoot())) / 4), y: p2.y - (barWidth / 4)), CGPoint(x: p2.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p2.y + (barWidth / 4)), CGPoint(x: p3.x - ((barWidth * CGFloat(3.squareRoot())) / 4), y: p3.y + (barWidth / 4))]
        path4.addLines(between: [ceBar[0], ceBar[1], ceBar[2], ceBar[3]])
        ceBG.path = path4
        ceBG.fillColor = SKColor.yellow
        ceBG.name = "ce_space"
        self.addChild(ceBG)
        // Create Climate
        climateBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        climateBG.position = p1
        climateBG.zPosition = 3
        climateBG.fillColor = SKColor.blue
        climateBG.name = "c_space"
        self.addChild(climateBG)
        // Create Weather
        weatherBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        weatherBG.position = p2
        weatherBG.zPosition = 3
        weatherBG.fillColor = SKColor.red
        weatherBG.name = "w_space"
        self.addChild(weatherBG)
        // Create Enviroment
        enviromBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        enviromBG.position = p3
        enviromBG.zPosition = 3
        enviromBG.fillColor = SKColor.green
        enviromBG.name = "e_space"
        self.addChild(enviromBG)
    }
}
