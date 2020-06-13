//
//  AppDelegate.swift
//  Climate Change Edu
//
//  Created by Patrick Moore on 5/15/19.
//  Copyright © 2019 Patrick Moore. All rights reserved.
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
    var numButtons: [SKNode]!
    var form: SKShapeNode!
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
    var SESSIONID:Int!
    var INSTRUCTID:String = "0"
    var SCHOOLID:String = "0"
    var ETHNICID:String = "0"
    var SEXID:String = "0"
    var AGEID:String = "0"
    var GRADEID:String = "0"
    func API1(){
        let endpoint1:String = "https://lk62rbimtg.execute-api.us-west-2.amazonaws.com/beta/session"
        guard let URL1 = URL(string: endpoint1) else {
            print("Error: Cannot create URL.")
            return
        }
        var URLRequest1 = URLRequest(url: URL1)
        URLRequest1.httpMethod = "POST"
        let newPost1: [String: Any] = ["instructor_id": INSTRUCTID, "school_id": SCHOOLID, "ethnicity_id": ETHNICID, "sex": SEXID, "age": AGEID, "grade": GRADEID]
        var jsonPost1:Data
        do {
            jsonPost1 = try JSONSerialization.data(withJSONObject: newPost1, options: [])
            URLRequest1.httpBody = jsonPost1
            print("\(jsonPost1)")
        } catch {
            print("Error: cannot create JSON")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: URLRequest1){
            (data, response, error) in
            guard error == nil else {
                print("Error: error in calling Post1")
                print(error ?? 0)
                return
            }
            guard let responseData = data else {
                print("Error: did not recieve data from Post1")
                return
            }
            // Parse responce
            do {
                guard let receivedPost1:[String: Any] = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                    print("Error: could not make response from Post1 into a dictionary")
                    return
                }
                print("json: \(receivedPost1)")
                guard let post1ID = receivedPost1["id"] as? Int else {
                    print("Error: could not receive the session ID")
                    return
                }
                self.SESSIONID = post1ID
                print("Session ID is: \(post1ID)")
            } catch let error {
                print("Error: error parsing response from Post1")
                print(error)
                return
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
            textFields[i].isHidden = true
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
                // Prints touch location (x, y)
                print(location)
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
                    zPosUpdater = zPosUpdater + 3
                    // Increases size of selected tile
                    if nodeToMove.name != "submit"{
                        nodeToMove.run(SKAction.scale(to: 1.4, duration: 0.2))
                    }
                    // Searches for underlying zone
                    nodeFound = false
                    for node in touchedNode {
                        print(node.name ?? "No Name")
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
                        } else if node.name == "submit" {
                            print("Submit!")
                            followDisable = true
                            stepForward1()
                            nodeFound = true
                            break
                        }
                    }
                    if !nodeFound && nodeToMove.position.y > (tileBankLocDict[13].y - tileHeight) {
                        // Prints underlying location
                        print("Bank pick!")
                        // Updates the count in the Bank
                        remainingInBank = remainingInBank - 1
                        // Displays submit option if Bank is empty
                        if remainingInBank == 0 {
                            makeSumbitVis = true
                            submit.zPosition = zPosUpdater
                            zPosUpdater = zPosUpdater + 3
                        }
                        // Prints remaining bank count
                        print(remainingInBank)
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
                                // Prints underlying location
                                print("C Circle!")
                                castedNode.fillColor = SKColor(red: 1/2, green: 1/2, blue: 1, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                break
                            } else if (node.name == "w_space") && (distance(locationEnd, p2) < circleWidth / 2) {
                                // Prints underlying location
                                print("W Circle!")
                                castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1/2, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                break
                            } else if (node.name == "e_space") && (distance(locationEnd, p3) < circleWidth / 2) {
                                // Prints underlying location
                                print("E Circle!")
                                castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1/2, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                break
                            }
                        } else if node.name == "cwe_space" && (locationEnd.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) {
                            // Prints underlying location
                            print("CWE Triangle!")
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                            nodeFound = true
                            break
                        } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            nodeFound = true
                            if node.name == "cw_space" {
                                // Prints underlying location
                                print("CW Bar!")
                                castedNode.fillColor = SKColor(red: 1, green: 1/2, blue: 1, alpha: 1)
                                break
                            } else if node.name == "we_space" && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) && (locationEnd.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (locationEnd.x - weBar[3].x) + weBar[3].y)) {
                                // Prints underlying location
                                print("WE Bar!")
                                nodeToMove.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
                                castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1/2, alpha: 1)
                            } else if node.name == "ce_space" && (locationEnd.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (locationEnd.x - ceBar[3].x) + ceBar[3].y)) && (locationEnd.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) {
                                // Prints underlying location
                                print("CE Bar!")
                                nodeToMove.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
                                castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1, alpha: 1)
                            }
                            break
                        } else if node.name == "na_space" {
                            // Prints underlying location
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 5/6, green: 5/6, blue: 5/6, alpha: 1)
                            print("None!")
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
    }
    
    private func initializeMenu() {
        // Declaring constants to determine object sizing
        // THE NEXT 200 lines are just dog shit code design. Good luck.
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        gameBG = SKShapeNode()
        self.addChild(gameBG)
        // Determines ratio
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
        // Create Combo Area
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
        // Create Combo Area
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
        // Create Combo Area
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
        // Create Climate Circle
        let climateBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        climateBG.position = p1
        climateBG.zPosition = 4
        climateBG.fillColor = SKColor.blue
        climateBG.strokeColor = SKColor.black
        climateBG.lineWidth = 4 * ratio
        climateBG.name = "c_space"
        gameBG.addChild(climateBG)
        // Create Weather Circle
        let weatherBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        weatherBG.position = p2
        weatherBG.zPosition = 4
        weatherBG.fillColor = SKColor.red
        weatherBG.strokeColor = SKColor.black
        weatherBG.lineWidth = 4 * ratio
        weatherBG.name = "w_space"
        gameBG.addChild(weatherBG)
        // Create Enviroment Circle
        let enviromBG = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        enviromBG.position = p3
        enviromBG.zPosition = 4
        enviromBG.fillColor = SKColor.green
        enviromBG.strokeColor = SKColor.black
        enviromBG.lineWidth = 4 * ratio
        enviromBG.name = "e_space"
        gameBG.addChild(enviromBG)
        // Create Immobile Bank Label
        let bankLabel = SKLabelNode(fontNamed: "ArialMT")
        bankLabel.text = "Word Bank"
        bankLabel.fontSize = 50 * ratio
        bankLabel.zPosition = 2
        bankLabel.position = CGPoint(x: naBG.frame.midX, y: naBG.frame.maxY + (25 * ratio))
        bankLabel.fontColor = SKColor.black
        gameBG.addChild(bankLabel)
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
        gameBG.addChild(cLabel)
        gameBG.addChild(wLabel)
        gameBG.addChild(eLabel)
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
        gameBG.addChild(cwLabel1)
        gameBG.addChild(cwLabel2)
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
        gameBG.addChild(ceLabel1)
        gameBG.addChild(ceLabel2)
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
        gameBG.addChild(weLabel1)
        gameBG.addChild(weLabel2)
        //Creates cwe labels
        var cweLabels:[SKLabelNode] = []
        for i in 0...2 {
            let cweLabel = SKLabelNode(fontNamed: "ArialMT")
            cweLabel.fontSize = 30 * ratio
            cweLabel.zPosition = 5
            cweLabel.fontColor = SKColor.black
            cweLabel.position = CGPoint(x: cweBG.frame.midX, y: cweBG.frame.midY + (cweLabel.fontSize * (3.8 - CGFloat(i)*1.4)))
            gameBG.addChild(cweLabel)
            cweLabels.append(cweLabel)
        }
        cweLabels[0].text = "Enviroment and"
        cweLabels[1].text = "Weather and"
        cweLabels[2].text = "Climate"
        // creates N/A lables
        for i in 0...3 {
            let naLabel = SKLabelNode(fontNamed: "ArialMT")
            naLabel.text = "unrelated"
            naLabel.fontSize = 30 * ratio
            naLabel.zPosition = 5
            naLabel.fontColor = SKColor.black
            naLabel.position = CGPoint(x: 7 * screenWidth / CGFloat((i%2)*40 - 20), y: (i/2 == 0) ? (weatherBG.frame.midY + (3 * enviromBG.frame.midY)) / 4 : (enviromBG.frame.midY - screenHeight) / 3)
            gameBG.addChild(naLabel)
        }
        // Establish draggable tiles in bulk
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
        var tile_labels:[SKLabelNode] = []
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
        // Assign tile properties, append to game board as children
        for i in 0...14 {
            //tile
            let tile = tile_shape.copy() as! SKShapeNode
            tile.position = tileBankLocDict[i]
            tiles.append(tile)
            gameBG.addChild(tile)
            //label
            let tile_label = tile_label_teplate.copy() as! SKLabelNode
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
        // Labels and associated position for tiels
        tile_labels[0].text = "Cooling\n temps "
        tile_labels[1].text = "Warming\n  temps "
        tile_labels[2].text = "   Fast \nchanges"
        tile_labels[3].text = "Moderate\nchanges"
        tile_labels[4].text = "   Slow \nchanges"
        tile_labels[5].text = "Farming"
        tile_labels[6].text = "Industry"
        tile_labels[7].text = "Local"
        tile_labels[8].text = "Regional"
        tile_labels[9].text = "Global"
        tile_labels[10].text = "Animals\n& plants"
        tile_labels[11].text = "People"
        tile_labels[12].text = "Forests"
        tile_labels[13].text = "Oceans"
        tile_labels[14].text = "Greenhouse\n      effect "
        // Aligns text within tile
        for i in 0...14 {
            tile_labels[i].numberOfLines = 3
            tile_labels[i].preferredMaxLayoutWidth = tileLengthOriginal
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
        // Initial screen mode
        form = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        form.name = "form"
        form.fillColor = SKColor.white
        form.strokeColor = SKColor.black
        form.zPosition = 8000
        self.addChild(form)
        // Middle screen mode
        passScreen = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        passScreen.name = "pass"
        passScreen.fillColor = SKColor.white
        passScreen.strokeColor = SKColor.black
        passScreen.zPosition = 8000
        self.addChild(passScreen)
        passScreen.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
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
        customize(textField: textFields[0], placeholder: "School Code")
        customize(textField: textFields[1], placeholder: "Grade")
        customize(textField: textFields[2], placeholder: "Age")
        customize(textField: textFields[3], placeholder: "Race")
        customize(textField: textFields[4], placeholder: "Gender")
        loginBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height/4,width:self.size.width/2,height:50),fillColor:SKColor.blue,title:"Begin Session",logo:nil,name:"loginBtn")
        loginBtn.zPosition = 9000
        form.addChild(loginBtn)
    }
}
