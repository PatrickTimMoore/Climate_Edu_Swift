//
//  AppDelegate.swift
//  Climate Change Edu
//
//  Created by Patrick Moore on 5/15/19.
//  Copyright © 2019-2020 Patrick Moore and Ross Toedte. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


protocol TransitionDelegate: SKSceneDelegate {
    func showAlert(title:String,message:String)
    func handleLoginBtn(username:String,password:String)
}

class GameScene: SKScene, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    //UIPicker setup -- manual magic values
    var school = ["Currently Unavailable"]
    var grade = ["1st grade", "2nd grade", "3rd grade", "4th grade", "5th grade", "6th grade", "7th grade", "8th grade", "9th grade", "10th grade", "11th grade", "12th grade"]
    var age = ["6 years old", "7 years old", "8 years old", "9 years old", "10 years old", "11 years old", "12 years old", "13 years old", "14 years old", "15 years old", "16 years old", "17 years old", "18 years old"]
    var race = ["White", "Black or African American", "American Indian", "Asian", "Mixed", "Other"]
    var gender = ["Male", "Female"]
    var textFields:[UITextField]!
    var pickers:[UIPickerView]!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickers[0] {
            return school.count
        } else if pickerView == pickers[1] {
            return grade.count
        } else if pickerView == pickers[2] {
            return age.count
        } else if pickerView == pickers[3] {
            return race.count
        } else if pickerView == pickers[4] {
            return gender.count
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickers[0] {
            return school[row]
        } else if pickerView == pickers[1] {
            return grade[row]
        } else if pickerView == pickers[2] {
            return age[row]
        } else if pickerView == pickers[3] {
            return race[row]
        } else if pickerView == pickers[4] {
            return gender[row]
        } else {
            return "0"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickers[0] {
            textFields[0].text = school[row]
            pickers[0].isHidden = true;
        } else if pickerView == pickers[1] {
            textFields[1].text = grade[row]
            pickers[1].isHidden = true;
        } else if pickerView == pickers[2] {
            textFields[2].text = age[row]
            pickers[2].isHidden = true;
        } else if pickerView == pickers[3] {
            textFields[3].text = race[row]
            pickers[3].isHidden = true;
        } else if pickerView == pickers[4] {
            textFields[4].text = gender[row]
            pickers[4].isHidden = true;
        } else {
            return
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFields.contains(textField) {
            pickers[(textFields.firstIndex(of: textField) ?? 0)].isHidden = false
            return false
        } else {
            return true
        }
    }
    
    //declaring varables used between initialization and in-game data
    var game: GameManager!
    var gameBG: SKShapeNode!
    var ceBar: [CGPoint]!
    var weBar: [CGPoint]!
    var p1: CGPoint!
    var p2: CGPoint!
    var p3: CGPoint!
    var tiles: [SKShapeNode]!
    var tile_labels: [SKLabelNode]!
    var tilePrev: [String] = []
    var tileCurr: [String] = []
    var numButtons: [SKNode]!
    var form: SKShapeNode!
    var questionForm: SKShapeNode!
    var passScreen: SKShapeNode!
    var submit: SKShapeNode!
    var submitLabel: SKLabelNode!
    var contBtn: SKShapeNode!
    var nodeToMove: SKNode!
    var locationOld: CGPoint!
    var zPosUpdater: CGFloat!
    var nodeFound: Bool!
    var makeSumbitVis: Bool = false
    var circleWidth: CGFloat!
    var bottomMargin: CGFloat!
    var midMargin: CGFloat!
    var tileBankLocDict: [CGPoint]!
    var remainingInBank: Int = 15
    var dictLookup: Int!
    var sequenceApp: Int = 1
    var spinLockState: Int = 0
    var followDisable: Bool = false
    var resetCounter: Int!
    var tileHeight: CGFloat!
    
    // UIKit Intergration
    var loginBtn:SKShapeNode!
    func customize(textField:UITextField, placeholder:String , isSecureTextEntry:Bool = false) {
        let paddingView = UIView(frame:CGRect(x:0,y: 0,width: 10,height: 30))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.leftViewMode = UITextField.ViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.textColor = .black
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = self
    }
    func getButton(frame:CGRect,fillColor:SKColor,title:String = "",logo:SKSpriteNode!,name:String)->SKShapeNode {
        let btn = SKShapeNode(rect: frame, cornerRadius: 10)
        btn.fillColor = fillColor
        btn.strokeColor = fillColor
        if let l = logo {
            btn.addChild(l)
            l.zPosition = 2
            l.position = CGPoint(x:frame.origin.x+(frame.size.width/2),y:frame.origin.y+(frame.size.height/2))
            l.name = name
        }
        if !title.isEmpty {
            let label = SKLabelNode.init(fontNamed: "AppleSDGothicNeo-Regular")
            label.text = title; label.fontSize = 25
            label.fontColor = .white
            btn.addChild(label)
            label.zPosition = 3
            label.position = CGPoint(x:frame.origin.x+(frame.size.width/2),y:frame.origin.y+(frame.size.height/4))
            label.name = name
        }
        btn.name = name
        return btn
    }
    
    // API Calls
    var SESSIONID:Int = 0
    var INSTRUCTID:String = "0"
    var SCHOOLID:String = "0"
    var ETHNICID:String = "0"
    var SEXID:String = "0"
    var AGEID:String = "0"
    var GRADEID:String = "0"
    func API1(){
        // Prepare URL
        let endpoint1:String = "https://lk62rbimtg.execute-api.us-west-2.amazonaws.com/beta/session"
        guard let URL1 = URL(string: endpoint1) else {
            print("Error: Cannot create URL.")
            return
        }
        // Prepare URL Request Obj
        var URLRequest1 = URLRequest(url: URL1)
        URLRequest1.httpMethod = "POST"
        let newPost1 = [
            "instructor_id": INSTRUCTID,
            "school_id": SCHOOLID,
            "ethnicity_id": ETHNICID,
            "sex": SEXID,
            "age": AGEID,
            "grade": GRADEID
        ]
        // Creates JSoN
        let jsonPost1 = try? JSONSerialization.data(withJSONObject: newPost1, options: [])
        URLRequest1.httpBody = jsonPost1
        URLRequest1.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest1){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post1")
                print(error ?? "No Data")
                return
            }
            // Parse responce
            let responseJSON1 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON1 as? [String: Any] {
                if let responseBody = responseJSON["body"] as? [String: Any] {
                    self.SESSIONID = (responseBody["id"] as! Int)
                } else {
                    print("Error: error in converting response body")
                }
            } else {
                print("Error: error in converting response data")
            }
        }
        task.resume()
    }
    
    // API Validators
    func validate1(){
        // Validate submit info and then send to SQL server
        // Then set up game
        for i in 0...4 {
            if textFields[i].text == "" || textFields[i].text == nil {
                return
            }
        }
        //ID handlers
        ETHNICID = "\(race.firstIndex(of: textFields[3].text!)! + 1)"
        SEXID = textFields[4].text == gender[1] ? "M" : "F"
        AGEID = "\(age.firstIndex(of: textFields[2].text!)! + 6)"
        GRADEID = "\(grade.firstIndex(of: textFields[1].text!)! + 1)"
        INSTRUCTID = "1" //TODO <- defualts Ross
        SCHOOLID = "0" //TODO <- defaults failure
        form.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        for i in 0...4 {
            textFields[i].isHidden = true
            pickers[i].isHidden = true
        }
        API1()
        sequenceApp = sequenceApp + 1
    }
    func stepForward1(){
        passScreen.run(SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: 0.3))
        passScreen.zPosition = zPosUpdater + 2
        contBtn.run(SKAction.fadeAlpha(to: 0, duration: 0))
        sequenceApp = sequenceApp + 1
        followDisable = false
    }
    func stepForward2(){
        passScreen.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        //API2()
        passScreen.zPosition = zPosUpdater + 2
        sequenceApp = sequenceApp + 1
        if submitLabel.text == "SUBMIT" {
            submitLabel.text = "FINISH"
        } else {
            submitLabel.text = "SUBMIT"
        }
        if sequenceApp == 6 {
            stepBackward2()
        }
    }
    func stepBackward1(){
        passScreen.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        sequenceApp = sequenceApp - 1
    }
    func stepBackward2(){
        form.run(SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: 0.3))
        for i in 0...4 {
            textFields[i].isHidden = false
        }
        resetCounter = 0
        for tile in tiles {
            tile.run(SKAction.move(by: CGVector(dx: tileBankLocDict[resetCounter].x - (tile.position.x), dy: tileBankLocDict[resetCounter].y - (tile.position.y)), duration: 0.3))
            if tile.fillColor == SKColor(red: 1/2, green: 1, blue: 1, alpha: 1) {
                tile.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
            }
            if tile.fillColor == SKColor(red: 1, green: 1, blue: 1/2, alpha: 1) {
                tile.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
            }
            tile.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
            tile.run(SKAction.scale(to: 1, duration: 0.2))
            submit.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
            resetCounter = resetCounter + 1
            // Updates bank count
            remainingInBank = remainingInBank + 1
        }
        remainingInBank = 15
        sequenceApp = 1
    }
    
    // Function runs on start of the aplication
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager(scene: self)
        zPosUpdater = 12
    }
    
    // Function runs on initial screen touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-click functionality here
        if sequenceApp == 1 {
            followDisable = true
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if node.name == "loginBtn" && !node.hasActions(){
                        validate1()
                        break
                    }
                }
            }
        } else if (sequenceApp == 2) || (sequenceApp == 4) {
            followDisable = false
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if (node.name == "tile" || node.name == "submit") && !node.hasActions(){
                        nodeToMove = node
                        locationOld = location
                        break
                    }
                }
                // Checks for tile node
                if nodeToMove != nil {
                    // Resets node to be of regular angle if not
                    let castedNode:SKShapeNode = nodeToMove as! SKShapeNode
                    if castedNode.fillColor == SKColor(red: 1/2, green: 1, blue: 1, alpha: 1) {
                        nodeToMove.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
                    }
                    if castedNode.fillColor == SKColor(red: 1, green: 1, blue: 1/2, alpha: 1) {
                        nodeToMove.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
                    }
                    // Updates z Position so that selected nodes always appear on top
                    nodeToMove.zPosition = zPosUpdater
                    zPosUpdater = zPosUpdater + 3
                    // Increases size of selected tile
                    if nodeToMove.name != "submit"{
                        nodeToMove.run(SKAction.scale(to: 1.4, duration: 0.2))
                    }
                    // Searches for underlying zone
                    nodeFound = false
                    for node in touchedNode {
                        if node.name == "c_space" || node.name == "w_space" || node.name == "e_space" {
                            if (node.name == "c_space") && (distance(location, p1) < circleWidth / 2) {
                                nodeFound = true
                                break
                            } else if (node.name == "w_space") && (distance(location, p2) < circleWidth / 2) {
                                nodeFound = true
                                break
                            } else if (node.name == "e_space") && (distance(location, p3) < circleWidth / 2) {
                                nodeFound = true
                                break
                            }
                        } else if node.name == "cwe_space" && (location.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) {
                            nodeFound = true
                            break
                        } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                            if node.name == "cw_space" {
                                nodeFound = true
                                break
                            } else if node.name == "we_space" && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) && (location.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (location.x - weBar[3].x) + weBar[3].y)) {
                                nodeFound = true
                                break
                            } else if node.name == "ce_space" && (location.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (location.x - ceBar[3].x) + ceBar[3].y)) && (location.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) {
                                nodeFound = true
                                break
                            }
                        } else if node.name == "na_space" {
                            nodeFound = true
                            break
                        } else if node.name == "submit" {
                            followDisable = true
                            stepForward1()
                            nodeFound = true
                            break
                        }
                    }
                    if !nodeFound && nodeToMove.position.y > (tileBankLocDict[13].y - tileHeight) {
                        // Updates the count in the Bank
                        remainingInBank = remainingInBank - 1
                        // Displays submit option if Bank is empty
                        if remainingInBank == 0 {
                            makeSumbitVis = true
                            submit.zPosition = zPosUpdater
                            zPosUpdater = zPosUpdater + 3
                        }
                    }
                }
            }
        } else if (sequenceApp == 3) || (sequenceApp == 5) {
            followDisable = true
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if node.name == "contBtn" && !node.hasActions(){
                        stepForward2()
                        spinLockState = 0
                        break
                    } else if node.name == "pass" {
                        break
                    } else if numButtons.contains(node) || numButtons.contains(node.parent ?? node) {
                        if (node.name == "numPad0" || node.parent!.name == "numPad0") && spinLockState == 3 {
                            spinLockState = 4
                            contBtn.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                            break
                        } else if (node.name == "numPad1" || node.parent!.name == "numPad1") && spinLockState == 2 {
                            spinLockState = 3
                            break
                        } else if (node.name == "numPad2" || node.parent!.name == "numPad2") && spinLockState == 1 {
                            spinLockState = 2
                            break
                        } else if (node.name == "numPad3" || node.parent!.name == "numPad3") {
                            spinLockState = 1
                            break
                        } else {
                            spinLockState = 0
                            break
                        }
                    } else {
                        stepBackward1()
                        submit.zPosition = zPosUpdater
                        zPosUpdater = zPosUpdater + 3
                        break
                    }
                }
            }
        }
    }
    
    // Function runs on dragging screen touch
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add on-drag functionality here
        // Checks if a node is currently selected
        if(followDisable){
            return
        } else {
            if nodeToMove != nil && nodeToMove.name != "submit" {
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
        if(followDisable){
            return
        } else {
            if nodeToMove != nil && nodeToMove.name != "submit" {
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
                                castedNode.fillColor = SKColor(red: 1/2, green: 1/2, blue: 1, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                break
                            } else if (node.name == "w_space") && (distance(locationEnd, p2) < circleWidth / 2) {
                                castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1/2, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                break
                            } else if (node.name == "e_space") && (distance(locationEnd, p3) < circleWidth / 2) {
                                castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1/2, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                break
                            }
                        } else if node.name == "cwe_space" && (locationEnd.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                            nodeFound = true
                            break
                        } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            nodeFound = true
                            if node.name == "cw_space" {
                                castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1, alpha: 1)
                                break
                            } else if node.name == "we_space" && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) && (locationEnd.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (locationEnd.x - weBar[3].x) + weBar[3].y)) {
                                nodeToMove.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
                                castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1/2, alpha: 1)
                            } else if node.name == "ce_space" && (locationEnd.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (locationEnd.x - ceBar[3].x) + ceBar[3].y)) && (locationEnd.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) {
                                nodeToMove.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
                                castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1, alpha: 1)
                            }
                            break
                        } else if node.name == "na_space" {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 5/6, green: 5/6, blue: 5/6, alpha: 1)
                            nodeFound = true
                            break
                        }
                    }
                    // If retruning tile to bank location
                    if !nodeFound {
                        // Returns tile to it's proper bank location
                        dictLookup = (tiles.firstIndex(of: castedNode) ?? 0)
                        nodeToMove.run(SKAction.move(by: CGVector(dx: tileBankLocDict[dictLookup].x - (nodeToMove.position.x), dy: tileBankLocDict[dictLookup].y - (nodeToMove.position.y)), duration: 0.3))
                        castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                        // Returns tile to normal side
                        nodeToMove.run(SKAction.scale(to: 1, duration: 0.2))
                        // Updates bank count
                        remainingInBank = remainingInBank + 1
                        // Hides submit if submit is a tile is selected
                        if remainingInBank == 1 {
                            submit.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                        }
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
    }
    
    private func initializeMenu() {
        // THE NEXT 80 lines are just dog shit code design. Good luck.
        // Declaring constants to determine object sizing
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        gameBG = SKShapeNode()
        self.addChild(gameBG)
        // Determines screen ratio to maintain constant size
        let ratio: CGFloat = (screenWidth / CGFloat(850))
        circleWidth = (ratio * CGFloat(270))
        let barWidth: CGFloat = ratio * 110
        let barLength: CGFloat = ratio * CGFloat(550)
        bottomMargin = ((screenHeight / -2) + (0.6 * circleWidth))
        midMargin = ((3 / 4) * barLength * barLength).squareRoot()
        // Declares size of tiles
        let tileLengthOriginal: CGFloat = ((1/9) * 850 * ratio)
        tileHeight = (tileLengthOriginal / 2)
        let tileLength = tileLengthOriginal + tileHeight
        // Declares center of the 3 circles as anchor points
        p1 = CGPoint(x: (barLength / -2), y: bottomMargin + midMargin)
        p2 = CGPoint(x: (barLength / 2), y: bottomMargin + midMargin)
        p3 = CGPoint(x: 0, y: bottomMargin)
        // Create N/A Area
        let naBG = SKShapeNode()
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
        gameBG.addChild(naBG)
        // Create Common Area
        let cweBG = SKShapeNode()
        cweBG.position = CGPoint(x: 0, y: 0)
        cweBG.zPosition = 2
        let path1 = CGMutablePath()
        path1.addLines(between: [p1, p2, p3])
        cweBG.path = path1
        cweBG.fillColor = SKColor.white
        cweBG.name = "cwe_space"
        gameBG.addChild(cweBG)
        // Create Combo Area 1
        let cwBG = SKShapeNode()
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
        gameBG.addChild(cwBG)
        // Create Combo Area 2
        let ceBG = SKShapeNode()
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
        gameBG.addChild(ceBG)
        // Create Combo Area 3
        let weBG = SKShapeNode()
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
        gameBG.addChild(weBG)
        let gameBarList = [ceBG, cwBG, weBG]
        // Create Climate, Weather, and Enviroment Circle
        var BG_circles:[SKShapeNode] = []
        let BG_circle_template = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        BG_circle_template.zPosition = 4
        BG_circle_template.strokeColor = SKColor.black
        BG_circle_template.lineWidth = 4 * ratio
        let BG_cicle_pos = [p1, p2, p3]
        let BG_cicle_color = [SKColor.blue, SKColor.red, SKColor.green]
        let BG_cicle_names = ["c_space", "w_space", "e_space"]
        for i in 0...2{
            let BG_circle = BG_circle_template.copy() as! SKShapeNode
            BG_circle.position = BG_cicle_pos[i]!
            BG_circle.fillColor = BG_cicle_color[i]
            BG_circle.name = BG_cicle_names[i]
            BG_circles.append(BG_circle)
            gameBG.addChild(BG_circle)
        }
        // Create Immobile Bank Label
        let bankLabel = SKLabelNode(fontNamed: "ArialMT")
        bankLabel.text = "Word Bank"
        bankLabel.fontSize = 50 * ratio
        bankLabel.zPosition = 2
        bankLabel.position = CGPoint(x: naBG.frame.midX, y: naBG.frame.maxY + (25 * ratio))
        bankLabel.fontColor = SKColor.black
        gameBG.addChild(bankLabel)
        // Create Immobile Circle Labels
        let circleLabelText = ["Climate", "Weather", "Enviroment"]
        for i in 0...2 {
            let cicleLabel = SKLabelNode(fontNamed: "ArialMT")
            cicleLabel.fontSize = 50 * ratio
            cicleLabel.position = CGPoint(x: BG_circles[i].frame.midX, y: BG_circles[i].frame.midY - (cicleLabel.fontSize / 2))
            cicleLabel.zPosition = 5
            cicleLabel.text = circleLabelText[i]
            gameBG.addChild(cicleLabel)
        }
        // Create Immobile Bar Labels
        let rotation1 = -60 * CGFloat.pi / 180
        let rotation2 = 60 * CGFloat.pi / 180
        let barLabelRotation = [rotation1, rotation1, 0, 0, rotation2, rotation2]
        let barLabelText = ["Climate and", "Enviroment", "Climate and", "Weather", "Enviroment", "and Weather"]
        let barLabelOriginX = [6 * ratio * CGFloat(3).squareRoot(), -15 * ratio * CGFloat(3).squareRoot(), 0, 0, -6 * ratio * CGFloat(3).squareRoot(), 15 * ratio * CGFloat(3).squareRoot()]
        let barLabelOriginY = [6 * ratio, -15 * ratio, 6 * ratio, -36 * ratio, 6 * ratio, -15 * ratio]
        for i in 0...5 {
            let barLabel = SKLabelNode(fontNamed: "ArialMT")
            barLabel.fontSize = 30 * ratio
            barLabel.zPosition = 5
            barLabel.fontColor = SKColor.black
            barLabel.zRotation = barLabelRotation[i]
            barLabel.text = barLabelText[i]
            barLabel.position = CGPoint(x: gameBarList[(i/2)].frame.midX + barLabelOriginX[i], y: gameBarList[(i/2)].frame.midY + barLabelOriginY[i])
            gameBG.addChild(barLabel)
        }
        //Creates cwe labels
        let cweLabelsText = ["Enviroment and", "Weather and", "Climate"]
        for i in 0...2 {
            let cweLabel = SKLabelNode(fontNamed: "ArialMT")
            cweLabel.text = cweLabelsText[i]
            cweLabel.fontSize = 30 * ratio
            cweLabel.zPosition = 5
            cweLabel.fontColor = SKColor.black
            cweLabel.position = CGPoint(x: cweBG.frame.midX, y: cweBG.frame.midY + (cweLabel.fontSize * (3.8 - CGFloat(i)*1.4)))
            gameBG.addChild(cweLabel)
        }
        // creates N/A lables
        for i in 0...3 {
            let naLabel = SKLabelNode(fontNamed: "ArialMT")
            naLabel.text = "unrelated"
            naLabel.fontSize = 30 * ratio
            naLabel.zPosition = 5
            naLabel.fontColor = SKColor.black
            naLabel.position = CGPoint(x: 7 * screenWidth / CGFloat((i%2)*40 - 20), y: (i/2 == 0) ? (BG_circles[1].frame.midY + (3 * BG_circles[2].frame.midY)) / 4 : (BG_circles[2].frame.midY - screenHeight) / 3)
            gameBG.addChild(naLabel)
        }
        // Establish draggable tiles in bulk
        // Creates locational tags for questionaire
        for _ in 0...14 {
            tilePrev.append("Bank")
            tileCurr.append("Bank")
        }
        // Dimentional variables
        let tileMin = bottomMargin + midMargin + (0.6 * circleWidth)
        let tileMax = screenHeight / 2
        let tileOffsetX = tileLength / -2
        let tileBufferX = screenWidth / 5.2
        // Create tile lookup table
        tileBankLocDict = []
        var x_pos_iter = tileOffsetX - (2 * tileBufferX) + (tileLength / 2)
        var y_pos_iter = ((tileMin + 3*tileMax) / 4) + (tileHeight / 2)
        while y_pos_iter >= ((3*tileMin + tileMax) / 4) + (tileHeight / 2) {
            while x_pos_iter <= tileOffsetX + (2 * tileBufferX) + (tileLength / 2){
                tileBankLocDict.append(CGPoint(x:x_pos_iter, y:y_pos_iter))
                x_pos_iter += tileBufferX
            }
            y_pos_iter += (tileMin - tileMax) / 4
            x_pos_iter = tileOffsetX - (2 * tileBufferX) + (tileLength / 2)
        }
        // Creates shape for tiles to be used
        let tile_shape = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 2), width: tileLength, height: tileHeight))
        tile_shape.name = "tile"
        tile_shape.fillColor = SKColor.white
        tile_shape.strokeColor = SKColor.black
        tile_shape.lineWidth = 2 * ratio
        tile_shape.zPosition = 6
        tiles = []
        tile_labels = []
        // Creates template for tile labels to be used
        let tile_label_teplate = SKLabelNode(fontNamed: "ArialMT")
        tile_label_teplate.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tile_label_teplate.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tile_label_teplate.fontSize = tileLengthOriginal / 6
        tile_label_teplate.position = CGPoint(x: (tileHeight / 2), y: 0)
        tile_label_teplate.fontColor = SKColor.black
        tile_label_teplate.zPosition = 2
        // Creates template for the tile static color TODO
        let tile_color_template = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        tile_color_template.zPosition = 1
        tile_color_template.strokeColor = SKColor.black
        // Create Sprite constants
        let temporaryValue1 = ((tileHeight - (2 * ratio)) - tileLength)
        let spriteOffset = (temporaryValue1 / 2) + (3 * ratio)
        let spritePos = CGPoint(x: spriteOffset, y: 0)
        let spriteSize = CGSize(width: tileHeight - (2 * ratio), height: tileHeight - (2 * ratio))
        // Labels and associated position for tiles
        let tile_labelsText = ["Cooling\n temps ", "Warming\n  temps ", "   Fast \nchanges", "Moderate\nchanges", "   Slow \nchanges", "Farming", "Industry", "Local", "Regional", "Global", "Animals\n& plants", "People", "Forests", "Oceans", "Greenhouse\n      effect "]
        let tile_labelsName = ["Cooling Temps", "Warming Temps", "Fast Changes", "Moderate Changes", "Slow Changes", "Farming", "Industry", "Local", "Regional", "Global", "Animals & Plants", "People", "Forests", "Oceans", "Greenhouse Effect"]
        // Assign tile properties, append to game board as children
        for i in 0...14 {
            //tile
            let tile = tile_shape.copy() as! SKShapeNode
            tile.position = tileBankLocDict[i]
            tiles.append(tile)
            gameBG.addChild(tile)
            //label
            let tile_label = tile_label_teplate.copy() as! SKLabelNode
            tile_label.text = tile_labelsText[i]
            tile_label.name = tile_labelsName[i]
            tile_label.numberOfLines = 3
            tile_label.preferredMaxLayoutWidth = tileLengthOriginal
            tile_labels.append(tile_label)
            tile.addChild(tile_label)
            //static color
            let tile_color = tile_color_template.copy() as! SKShapeNode
            if 0...1 ~= i {
                tile_color.fillColor = SKColor.yellow
            } else if 2...4 ~= i {
                tile_color.fillColor = SKColor.green
            } else if 5...6 ~= i {
                tile_color.fillColor = SKColor.cyan
            } else if 7...9 ~= i {
                tile_color.fillColor = SKColor.red
            } else if 10...14 ~= i {
                tile_color.fillColor = SKColor.blue
            }
            tile.addChild(tile_color)
            //sprite
            let tileSprite = SKSpriteNode(imageNamed: "TileSprite-\(i+1)")
            tileSprite.size = spriteSize
            tileSprite.position = spritePos
            tileSprite.zPosition = 1
            tile.addChild(tileSprite)
        }
        // Submit button
        submit = SKShapeNode.init(ellipseOf: CGSize.init(width: screenWidth/3, height: screenWidth/10))
        submit.position = CGPoint(x: naBG.frame.midX, y: (naBG.frame.maxY + screenHeight/2)/2)
        submit.zPosition = -5
        submit.fillColor = SKColor.systemBlue
        submit.alpha = 0
        submit.strokeColor = SKColor.black
        submit.name = "submit"
        gameBG.addChild(submit)
        // Creates text to lay on button
        submitLabel = SKLabelNode(fontNamed: "ArialMT")
        submitLabel.text = "SUBMIT"
        submitLabel.fontColor = SKColor.white
        submitLabel.zPosition = 0
        submitLabel.fontSize = 40 * ratio
        submitLabel.position = CGPoint(x: 0, y: -submitLabel.frame.height / 2)
        submit.addChild(submitLabel)
        // Initial screen mode and question prompt
        form = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        questionForm = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        passScreen = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        passScreen.name = "pass"
        let formCrew = [form, questionForm, passScreen]
        for forms in formCrew {
            forms!.fillColor = SKColor.white
            forms!.strokeColor = SKColor.black
            forms!.zPosition = 8000
            self.addChild(forms!)
            if forms! != form {
                forms!.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
            }
        }
        contBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height/4,width:self.size.width/2,height:50), fillColor:SKColor.blue, title:"Continue Session", logo:nil, name:"contBtn")
        contBtn.zPosition = 1
        // Creates numberpad for password screen
        let numPad_template = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad_template.fillColor = SKColor.lightGray
        numPad_template.zPosition = 1
        numButtons = []
        let numPadtxt_template = SKLabelNode(fontNamed: "ArialMT")
        numPadtxt_template.zPosition = 0
        numPadtxt_template.fontSize = 45 * ratio
        numPadtxt_template.position = CGPoint(x: 0, y: -numPadtxt_template.frame.height / 2)
        for i in 0...9 {
            let numPad = numPad_template.copy() as! SKShapeNode
            numPad.name = "numPad\(i)"
            if i > 0 {
                let i_mod_3_adj:CGFloat = CGFloat((i - 1) % 3) - 1
                let i_floor_3:CGFloat = CGFloat((i - 1) / 3)
                numPad.position.x = 2.2 * i_mod_3_adj * screenWidth * 0.9/15
                numPad.position.y = 2.2 * (3 - i_floor_3) * screenWidth * 0.9/15
            }
            numButtons.append(numPad)
            let numPadtxt = numPadtxt_template.copy() as! SKLabelNode
            numPadtxt.text = "\(i)"
            numPad.addChild(numPadtxt)
            passScreen.addChild(numPad)
        }
        passScreen.addChild(contBtn)
        // Add text fields/pickers for initial state
        guard let view = self.view else { return }
        let originX = (view.frame.size.width - view.frame.size.width/1.5)/2
        pickers = []
        textFields = []
        for i in 0...4 {
            let picker = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 216, width: view.frame.size.width, height: 216))
            picker.dataSource = self
            picker.delegate = self
            picker.backgroundColor = UIColor.white
            picker.isHidden = true;
            pickers.append(picker)
            view.addSubview(picker)
            let textField = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5 + CGFloat(i * 60), width: view.frame.size.width/1.5, height: 30))
            textFields.append(textField)
            view.addSubview(textField)
        }
        let textFieldPlacholders = ["School Code", "Grade", "Age", "Race", "Gender"]
        for i in 0...4{
            customize(textField: textFields[i], placeholder: textFieldPlacholders[i])
        }
        loginBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height/4,width:self.size.width/2,height:50),fillColor:SKColor.blue,title:"Begin Session",logo:nil,name:"loginBtn")
        loginBtn.zPosition = 9000
        form.addChild(loginBtn)
    }
}
