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
    //UIPicker setup
    var school = ["Currently Unavailable"]
    var grade = ["1st grade", "2nd grade", "3rd grade", "4th grade", "5th grade", "6th grade", "7th grade", "8th grade", "9th grade", "10th grade", "11th grade", "12th grade"]
    var age = ["6 years old", "7 years old", "8 years old", "9 years old", "10 years old", "11 years old", "12 years old", "13 years old", "14 years old", "15 years old", "16 years old", "17 years old", "18 years old"]
    var race = ["White", "Black or African American", "American Indian", "Asian", "Mixed", "Other"]
    var gender = ["Male", "Female"]
    var textField1:UITextField!
    var textField2:UITextField!
    var textField3:UITextField!
    var textField4:UITextField!
    var textField5:UITextField!
    var picker1:UIPickerView!
    var picker2:UIPickerView!
    var picker3:UIPickerView!
    var picker4:UIPickerView!
    var picker5:UIPickerView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker1 {
            return school.count
        } else if pickerView == picker2 {
            return grade.count
        } else if pickerView == picker3 {
            return age.count
        } else if pickerView == picker4 {
            return race.count
        } else if pickerView == picker5 {
            return gender.count
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker1 {
            return school[row]
        } else if pickerView == picker2 {
            return grade[row]
        } else if pickerView == picker3 {
            return age[row]
        } else if pickerView == picker4 {
            return race[row]
        } else if pickerView == picker5 {
            return gender[row]
        } else {
            return "0"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker1 {
            textField1.text = school[row]
            picker1.isHidden = true;
        } else if pickerView == picker2 {
            textField2.text = grade[row]
            picker2.isHidden = true;
        } else if pickerView == picker3 {
            textField3.text = age[row]
            picker3.isHidden = true;
        } else if pickerView == picker4 {
            textField4.text = race[row]
            picker4.isHidden = true;
        } else if pickerView == picker5 {
            textField5.text = gender[row]
            picker5.isHidden = true;
        } else {
            return
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textField1 {
            picker1.isHidden = false
            return false
        } else if textField == textField2 {
            picker2.isHidden = false
            return false
        } else if textField == textField3 {
            picker3.isHidden = false
            return false
        } else if textField == textField4 {
            picker4.isHidden = false
            return false
        } else if textField == textField5 {
            picker5.isHidden = false
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
    var numButtonsLabels: [SKNode]!
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
        // TODO
        // Then set up game
        if(textField1.text == "" || textField2.text == "" || textField3.text == "" || textField4.text == "" || textField5.text == ""){
            return
        }
        //ID handlers
        if(textField4.text == race[0]){
            ETHNICID = "1"
        } else if(textField4.text == race[1]){
            ETHNICID = "2"
        } else if(textField4.text == race[2]){
            ETHNICID = "3"
        } else if(textField4.text == race[3]){
            ETHNICID = "4"
        } else if(textField4.text == race[4]){
            ETHNICID = "5"
        } else if(textField4.text == race[5]){
            ETHNICID = "6"
        } else {
            ETHNICID = "0" //Defaults 0 on failure
        }
        if(textField5.text == gender[0]){
            SEXID = "M"
        } else if(textField5.text == gender[1]){
            SEXID = "F"
        } else {
            SEXID = "0" //Defaults 0 on failure
        }
        if(textField3.text == age[0]){
            AGEID = "6"
        } else if(textField3.text == age[1]){
            AGEID = "7"
        } else if(textField3.text == age[2]){
            AGEID = "8"
        } else if(textField3.text == age[3]){
            AGEID = "9"
        } else if(textField3.text == age[4]){
            AGEID = "10"
        } else if(textField3.text == age[5]){
            AGEID = "11"
        } else if(textField3.text == age[6]){
            AGEID = "12"
        } else if(textField3.text == age[7]){
            AGEID = "13"
        } else if(textField3.text == age[8]){
            AGEID = "14"
        } else if(textField3.text == age[9]){
            AGEID = "15"
        } else if(textField3.text == age[10]){
            AGEID = "16"
        } else if(textField3.text == age[11]){
            AGEID = "17"
        } else if(textField3.text == age[12]){
            AGEID = "18"
        } else {
            AGEID = "0" //Defaults 0 on failure
        }
        if(textField2.text == grade[0]){
            GRADEID = "1"
        } else if(textField2.text == grade[1]){
            GRADEID = "2"
        } else if(textField2.text == grade[2]){
            GRADEID = "3"
        } else if(textField2.text == grade[3]){
            GRADEID = "4"
        } else if(textField2.text == grade[4]){
            GRADEID = "5"
        } else if(textField2.text == grade[5]){
            GRADEID = "6"
        } else if(textField2.text == grade[6]){
            GRADEID = "7"
        } else if(textField2.text == grade[7]){
            GRADEID = "8"
        } else if(textField2.text == grade[8]){
            GRADEID = "9"
        } else if(textField2.text == grade[9]){
            GRADEID = "10"
        } else if(textField2.text == grade[10]){
            GRADEID = "11"
        } else if(textField2.text == grade[11]){
            GRADEID = "12"
        } else {
            GRADEID = "0" //Defaults 0 on failure
        }
        INSTRUCTID = "1" //TODO <- defualts Ross
        SCHOOLID = "0" //TODO <- defaults failure
        form.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        textField1.isHidden = true
        textField2.isHidden = true
        textField3.isHidden = true
        textField4.isHidden = true
        textField5.isHidden = true
        picker1.isHidden = true
        picker2.isHidden = true
        picker3.isHidden = true
        picker4.isHidden = true
        picker5.isHidden = true
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
        textField1.isHidden = false
        textField2.isHidden = false
        textField3.isHidden = false
        textField4.isHidden = false
        textField5.isHidden = false
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
                        break
                    } else if node.name == "pass" {
                        break
                    } else if numButtons.contains(node) || numButtonsLabels.contains(node) {
                        if (node.name == "numPad3" || node.parent!.name == "numPad3") && spinLockState == 0 {
                            spinLockState = 1
                            break
                        } else if (node.name == "numPad2" || node.parent!.name == "numPad2") && spinLockState == 1 {
                            spinLockState = 2
                            break
                        } else if (node.name == "numPad1" || node.parent!.name == "numPad1") && spinLockState == 2 {
                            spinLockState = 3
                            break
                        } else if (node.name == "numPad0" || node.parent!.name == "numPad0") && spinLockState == 3 {
                            spinLockState = 4
                            contBtn.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
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
        gameBG.addChild(cweLabel1)
        gameBG.addChild(cweLabel2)
        gameBG.addChild(cweLabel3)
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
        gameBG.addChild(naLabel1)
        gameBG.addChild(naLabel2)
        gameBG.addChild(naLabel3)
        gameBG.addChild(naLabel4)
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
        // Assign tile and tile label properties, append to game board as children
        for i in 0...14 {
            let tile = tile_shape.copy() as! SKShapeNode
            tile.position = tileBankLocDict[i]
            tiles.append(tile)
            gameBG.addChild(tile)
            let tile_label = tile_label_teplate.copy() as! SKLabelNode
            tile_labels.append(tile_label)
            tiles[i].addChild(tile_label)
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
        // Add color Static to background the tile labels
        let tileStaticCol1 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol2 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol3 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol4 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol5 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol6 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol7 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol8 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol9 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol10 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol11 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol12 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol13 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol14 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        let tileStaticCol15 = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2) + tileHeight, y: -(tileHeight / 2), width: tileLength - tileHeight, height: tileHeight))
        tileStaticCol1.zPosition = 1
        tileStaticCol2.zPosition = 1
        tileStaticCol3.zPosition = 1
        tileStaticCol4.zPosition = 1
        tileStaticCol5.zPosition = 1
        tileStaticCol6.zPosition = 1
        tileStaticCol7.zPosition = 1
        tileStaticCol8.zPosition = 1
        tileStaticCol9.zPosition = 1
        tileStaticCol10.zPosition = 1
        tileStaticCol11.zPosition = 1
        tileStaticCol12.zPosition = 1
        tileStaticCol13.zPosition = 1
        tileStaticCol14.zPosition = 1
        tileStaticCol15.zPosition = 1
        tileStaticCol1.fillColor = SKColor.yellow
        tileStaticCol2.fillColor = SKColor.yellow
        tileStaticCol3.fillColor = SKColor.green
        tileStaticCol4.fillColor = SKColor.green
        tileStaticCol5.fillColor = SKColor.green
        tileStaticCol6.fillColor = SKColor.cyan
        tileStaticCol7.fillColor = SKColor.cyan
        tileStaticCol8.fillColor = SKColor.red
        tileStaticCol9.fillColor = SKColor.red
        tileStaticCol10.fillColor = SKColor.red
        tileStaticCol11.fillColor = SKColor.blue
        tileStaticCol12.fillColor = SKColor.blue
        tileStaticCol13.fillColor = SKColor.blue
        tileStaticCol14.fillColor = SKColor.blue
        tileStaticCol15.fillColor = SKColor.blue
        tileStaticCol1.strokeColor = SKColor.black
        tileStaticCol2.strokeColor = SKColor.black
        tileStaticCol3.strokeColor = SKColor.black
        tileStaticCol4.strokeColor = SKColor.black
        tileStaticCol5.strokeColor = SKColor.black
        tileStaticCol6.strokeColor = SKColor.black
        tileStaticCol7.strokeColor = SKColor.black
        tileStaticCol8.strokeColor = SKColor.black
        tileStaticCol9.strokeColor = SKColor.black
        tileStaticCol10.strokeColor = SKColor.black
        tileStaticCol11.strokeColor = SKColor.black
        tileStaticCol12.strokeColor = SKColor.black
        tileStaticCol13.strokeColor = SKColor.black
        tileStaticCol14.strokeColor = SKColor.black
        tileStaticCol15.strokeColor = SKColor.black
        tiles[0].addChild(tileStaticCol1)
        tiles[1].addChild(tileStaticCol2)
        tiles[2].addChild(tileStaticCol3)
        tiles[3].addChild(tileStaticCol4)
        tiles[4].addChild(tileStaticCol5)
        tiles[5].addChild(tileStaticCol6)
        tiles[6].addChild(tileStaticCol7)
        tiles[7].addChild(tileStaticCol8)
        tiles[8].addChild(tileStaticCol9)
        tiles[9].addChild(tileStaticCol10)
        tiles[10].addChild(tileStaticCol11)
        tiles[11].addChild(tileStaticCol12)
        tiles[12].addChild(tileStaticCol13)
        tiles[13].addChild(tileStaticCol14)
        tiles[14].addChild(tileStaticCol15)
        // Create Sprite constants
        let temporaryValue1 = ((tileHeight - (2 * ratio)) - tiles[0].frame.width)
        let spriteOffset = (temporaryValue1 / 2) + (3 * ratio)
        let spritePos = CGPoint(x: spriteOffset, y: 0)
        let spriteSize = CGSize(width: tileHeight - (2 * ratio), height: tileHeight - (2 * ratio))
        // Initialize sprites to images
        let tileSprite1 = SKSpriteNode(imageNamed: "TileSprite-1")
        let tileSprite2 = SKSpriteNode(imageNamed: "TileSprite-2")
        let tileSprite3 = SKSpriteNode(imageNamed: "TileSprite-3")
        let tileSprite4 = SKSpriteNode(imageNamed: "TileSprite-4")
        let tileSprite5 = SKSpriteNode(imageNamed: "TileSprite-5")
        let tileSprite6 = SKSpriteNode(imageNamed: "TileSprite-6")
        let tileSprite7 = SKSpriteNode(imageNamed: "TileSprite-7")
        let tileSprite8 = SKSpriteNode(imageNamed: "TileSprite-8")
        let tileSprite9 = SKSpriteNode(imageNamed: "TileSprite-9")
        let tileSprite10 = SKSpriteNode(imageNamed: "TileSprite-10")
        let tileSprite11 = SKSpriteNode(imageNamed: "TileSprite-11")
        let tileSprite12 = SKSpriteNode(imageNamed: "TileSprite-12")
        let tileSprite13 = SKSpriteNode(imageNamed: "TileSprite-13")
        let tileSprite14 = SKSpriteNode(imageNamed: "TileSprite-14")
        let tileSprite15 = SKSpriteNode(imageNamed: "TileSprite-15")
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
        tiles[0].addChild(tileSprite1)
        tiles[1].addChild(tileSprite2)
        tiles[2].addChild(tileSprite3)
        tiles[3].addChild(tileSprite4)
        tiles[4].addChild(tileSprite5)
        tiles[5].addChild(tileSprite6)
        tiles[6].addChild(tileSprite7)
        tiles[7].addChild(tileSprite8)
        tiles[8].addChild(tileSprite9)
        tiles[9].addChild(tileSprite10)
        tiles[10].addChild(tileSprite11)
        tiles[11].addChild(tileSprite12)
        tiles[12].addChild(tileSprite13)
        tiles[13].addChild(tileSprite14)
        tiles[14].addChild(tileSprite15)
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
        let numPad0 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad0.fillColor = SKColor.lightGray
        numPad0.name = "numPad0"
        numPad0.zPosition = 1
        passScreen.addChild(numPad0)
        let numPad0txt = SKLabelNode(fontNamed: "ArialMT")
        numPad0txt.text = "0"
        numPad0txt.zPosition = 0
        numPad0txt.fontSize = 45 * ratio
        numPad0txt.position = CGPoint(x: 0, y: -numPad0txt.frame.height / 2)
        numPad0.addChild(numPad0txt)
        let numPad1 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad1.fillColor = SKColor.lightGray
        numPad1.name = "numPad1"
        numPad1.zPosition = 1
        numPad1.position.x = -2.2*passScreen.frame.width/15
        numPad1.position.y = 6.6*passScreen.frame.width/15
        passScreen.addChild(numPad1)
        let numPad1txt = SKLabelNode(fontNamed: "ArialMT")
        numPad1txt.text = "1"
        numPad1txt.zPosition = 0
        numPad1txt.fontSize = 45 * ratio
        numPad1txt.position = CGPoint(x: 0, y: -numPad1txt.frame.height / 2)
        numPad1.addChild(numPad1txt)
        let numPad2 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad2.fillColor = SKColor.lightGray
        numPad2.name = "numPad2"
        numPad2.zPosition = 1
        numPad2.position.y = 6.6*passScreen.frame.width/15
        passScreen.addChild(numPad2)
        let numPad2txt = SKLabelNode(fontNamed: "ArialMT")
        numPad2txt.text = "2"
        numPad2txt.zPosition = 0
        numPad2txt.fontSize = 45 * ratio
        numPad2txt.position = CGPoint(x: 0, y: -numPad2txt.frame.height / 2)
        numPad2.addChild(numPad2txt)
        let numPad3 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad3.fillColor = SKColor.lightGray
        numPad3.name = "numPad3"
        numPad3.zPosition = 1
        numPad3.position.x = 2.2*passScreen.frame.width/15
        numPad3.position.y = 6.6*passScreen.frame.width/15
        passScreen.addChild(numPad3)
        let numPad3txt = SKLabelNode(fontNamed: "ArialMT")
        numPad3txt.text = "3"
        numPad3txt.zPosition = 0
        numPad3txt.fontSize = 45 * ratio
        numPad3txt.position = CGPoint(x: 0, y: -numPad3txt.frame.height / 2)
        numPad3.addChild(numPad3txt)
        let numPad4 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad4.fillColor = SKColor.lightGray
        numPad4.name = "numPad4"
        numPad4.zPosition = 1
        numPad4.position.x = -2.2*passScreen.frame.width/15
        numPad4.position.y = 4.4*passScreen.frame.width/15
        passScreen.addChild(numPad4)
        let numPad4txt = SKLabelNode(fontNamed: "ArialMT")
        numPad4txt.text = "4"
        numPad4txt.zPosition = 0
        numPad4txt.fontSize = 45 * ratio
        numPad4txt.position = CGPoint(x: 0, y: -numPad4txt.frame.height / 2)
        numPad4.addChild(numPad4txt)
        let numPad5 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad5.fillColor = SKColor.lightGray
        numPad5.name = "numPad5"
        numPad5.zPosition = 1
        numPad5.position.y = 4.4*passScreen.frame.width/15
        passScreen.addChild(numPad5)
        let numPad5txt = SKLabelNode(fontNamed: "ArialMT")
        numPad5txt.text = "5"
        numPad5txt.zPosition = 0
        numPad5txt.fontSize = 45 * ratio
        numPad5txt.position = CGPoint(x: 0, y: -numPad5txt.frame.height / 2)
        numPad5.addChild(numPad5txt)
        let numPad6 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad6.fillColor = SKColor.lightGray
        numPad6.name = "numPad6"
        numPad6.zPosition = 1
        numPad6.position.x = 2.2*passScreen.frame.width/15
        numPad6.position.y = 4.4*passScreen.frame.width/15
        passScreen.addChild(numPad6)
        let numPad6txt = SKLabelNode(fontNamed: "ArialMT")
        numPad6txt.text = "6"
        numPad6txt.zPosition = 0
        numPad6txt.fontSize = 45 * ratio
        numPad6txt.position = CGPoint(x: 0, y: -numPad6txt.frame.height / 2)
        numPad6.addChild(numPad6txt)
        let numPad7 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad7.fillColor = SKColor.lightGray
        numPad7.name = "numPad7"
        numPad7.zPosition = 1
        numPad7.position.x = -2.2*passScreen.frame.width/15
        numPad7.position.y = 2.2*passScreen.frame.width/15
        passScreen.addChild(numPad7)
        let numPad7txt = SKLabelNode(fontNamed: "ArialMT")
        numPad7txt.text = "7"
        numPad7txt.zPosition = 0
        numPad7txt.fontSize = 45 * ratio
        numPad7txt.position = CGPoint(x: 0, y: -numPad7txt.frame.height / 2)
        numPad7.addChild(numPad7txt)
        let numPad8 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad8.fillColor = SKColor.lightGray
        numPad8.name = "numPad8"
        numPad8.zPosition = 1
        numPad8.position.y = 2.2*passScreen.frame.width/15
        passScreen.addChild(numPad8)
        let numPad8txt = SKLabelNode(fontNamed: "ArialMT")
        numPad8txt.text = "8"
        numPad8txt.zPosition = 0
        numPad8txt.fontSize = 45 * ratio
        numPad8txt.position = CGPoint(x: 0, y: -numPad8txt.frame.height / 2)
        numPad8.addChild(numPad8txt)
        let numPad9 = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad9.fillColor = SKColor.lightGray
        numPad9.name = "numPad9"
        numPad9.zPosition = 1
        numPad9.position.x = 2.2*passScreen.frame.width/15
        numPad9.position.y = 2.2*passScreen.frame.width/15
        passScreen.addChild(numPad9)
        let numPad9txt = SKLabelNode(fontNamed: "ArialMT")
        numPad9txt.text = "9"
        numPad9txt.zPosition = 0
        numPad9txt.fontSize = 45 * ratio
        numPad9txt.position = CGPoint(x: 0, y: -numPad9txt.frame.height / 2)
        numPad9.addChild(numPad9txt)
        passScreen.addChild(contBtn)
        numButtons = [numPad0, numPad1, numPad2, numPad3, numPad4, numPad5, numPad6, numPad7, numPad8, numPad9]
        numButtonsLabels = [numPad0txt, numPad1txt, numPad2txt, numPad3txt, numPad4txt, numPad5txt, numPad6txt, numPad7txt, numPad8txt, numPad9txt]
        // Add text fields
        guard let view = self.view else { return }
        let originX = (view.frame.size.width - view.frame.size.width/1.5)/2
        picker1  = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 216, width: view.frame.size.width, height: 216))
        picker1.dataSource = self
        picker1.delegate = self
        picker1.backgroundColor = UIColor.white
        picker1.isHidden = true;
        view.addSubview(picker1)
        picker2  = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 216, width: view.frame.size.width, height: 216))
        picker2.dataSource = self
        picker2.delegate = self
        picker2.backgroundColor = UIColor.white
        picker2.isHidden = true;
        view.addSubview(picker2)
        picker3  = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 216, width: view.frame.size.width, height: 216))
        picker3.dataSource = self
        picker3.delegate = self
        picker3.backgroundColor = UIColor.white
        picker3.isHidden = true;
        view.addSubview(picker3)
        picker4  = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 216, width: view.frame.size.width, height: 216))
        picker4.dataSource = self
        picker4.delegate = self
        picker4.backgroundColor = UIColor.white
        picker4.isHidden = true;
        view.addSubview(picker4)
        picker5  = UIPickerView(frame:CGRect(x: 0, y: view.frame.size.height - 216, width: view.frame.size.width, height: 216))
        picker5.dataSource = self
        picker5.delegate = self
        picker5.backgroundColor = UIColor.white
        picker5.isHidden = true;
        view.addSubview(picker5)
        textField1 = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5, width: view.frame.size.width/1.5, height: 30))
        customize(textField: textField1, placeholder: "School Code")
        view.addSubview(textField1)
        textField2 = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5+60, width: view.frame.size.width/1.5, height: 30))
        customize(textField: textField2, placeholder: "Grade")
        view.addSubview(textField2)
        textField3 = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5+120, width: view.frame.size.width/1.5, height: 30))
        customize(textField: textField3, placeholder: "Age")
        view.addSubview(textField3)
        textField4 = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5+180, width: view.frame.size.width/1.5, height: 30))
        customize(textField: textField4, placeholder: "Race")
        view.addSubview(textField4)
        textField5 = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5+240, width: view.frame.size.width/1.5, height: 30))
        customize(textField: textField5, placeholder: "Gender")
        view.addSubview(textField5)
        loginBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height/4,width:self.size.width/2,height:50),fillColor:SKColor.blue,title:"Begin Session",logo:nil,name:"loginBtn")
        loginBtn.zPosition = 9000
        form.addChild(loginBtn)
    }
}
