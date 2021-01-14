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
    var ratio: CGFloat!
    var p1: CGPoint!
    var p2: CGPoint!
    var p3: CGPoint!
    var tileIndex: Int!
    var stat_label_1: SKLabelNode!
    var stat_label_2: SKLabelNode!
    var stat_tiles: [SKShapeNode] = []
    var stat_tile_labels: [SKLabelNode] = []
    var tiles: [SKShapeNode]!
    var tile_labels: [SKLabelNode]!
    var tilePrev: [String] = []
    var tileCurr: [String] = []
    var tileBankLocDict: [CGPoint]!
    var stat_tileBankLocDict: [CGPoint]!
    var tileBankTranslator: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    var spriteSize: CGSize!
    var spritePos: CGPoint!
    var numButtons: [SKNode]!
    var numAttempt: [SKShapeNode]!
    var attempt: Int = 0
    var form: SKShapeNode!
    var questionForm: SKShapeNode!
    var passScreen: SKShapeNode!
    var statScreen: SKShapeNode!
    var submit: SKShapeNode!
    var submitLabel: SKLabelNode!
    var statBtn: SKShapeNode!
    var contBtn: SKShapeNode!
    var questionBtn: SKShapeNode!
    var nodeToMove: SKNode!
    var locationOld: CGPoint!
    var zPosUpdater: CGFloat!
    var nodeFound: Bool!
    var makeSumbitVis: Bool = false
    var circleWidth: CGFloat!
    var bottomMargin: CGFloat!
    var midMargin: CGFloat!
    var remainingInBank: Int = 15
    var dictLookup: Int!
    var sequenceApp: Int = 1
    var questionState: Bool = false
    var spinLockState: Int = 0
    var followDisable: Bool = false
    var resetCounter: Int!
    var tileHeight: CGFloat!
    var startTime: NSDate!
    var clickTime: NSDate!
    var currTime: NSDate!
    var sessLabel: SKLabelNode!
    var previousSessionField: UITextField!
    var oldStats: Array<Any> = Array(repeating: NSNull(), count: 30)
    var newStats: Array<Any> = Array(repeating: NSNull(), count: 30)
    var oldStat1img: SKSpriteNode! = nil
    var oldStat2img: SKSpriteNode! = nil
    var oldStat3img: SKSpriteNode! = nil
    var oldStat4img: SKSpriteNode! = nil
    var oldStat5img: SKSpriteNode! = nil
    var oldStat6img: SKSpriteNode! = nil
    var oldStat7img: SKSpriteNode! = nil
    var oldStat8img: SKSpriteNode! = nil
    var oldStat9img: SKSpriteNode! = nil
    var oldStat10img: SKSpriteNode! = nil
    var oldStat11img: SKSpriteNode! = nil
    var oldStat12img: SKSpriteNode! = nil
    var oldStat13img: SKSpriteNode! = nil
    var oldStat14img: SKSpriteNode! = nil
    var oldStat15img: SKSpriteNode! = nil
    var oldStat16img: SKSpriteNode! = nil
    var oldStat17img: SKSpriteNode! = nil
    var oldStat18img: SKSpriteNode! = nil
    var newStat1img: SKSpriteNode! = nil
    var newStat2img: SKSpriteNode! = nil
    var newStat3img: SKSpriteNode! = nil
    var newStat4img: SKSpriteNode! = nil
    var newStat5img: SKSpriteNode! = nil
    var newStat6img: SKSpriteNode! = nil
    var newStat7img: SKSpriteNode! = nil
    var newStat8img: SKSpriteNode! = nil
    var newStat9img: SKSpriteNode! = nil
    var newStat10img: SKSpriteNode! = nil
    var newStat11img: SKSpriteNode! = nil
    var newStat12img: SKSpriteNode! = nil
    var newStat13img: SKSpriteNode! = nil
    var newStat14img: SKSpriteNode! = nil
    var newStat15img: SKSpriteNode! = nil
    var newStat16img: SKSpriteNode! = nil
    var newStat17img: SKSpriteNode! = nil
    var newStat18img: SKSpriteNode! = nil
    var oldStatImgs: [SKSpriteNode?]!
    var newStatImgs: [SKSpriteNode?]!
    var spinLockAPI: Bool = false
    //UIButton setup -- manual magic values
    var questionPrompt1: SKLabelNode = SKLabelNode(fontNamed: "ArialMT")
    var q1: SKLabelNode = SKLabelNode(fontNamed: "ArialMT")
    var q1sol: [SKNode] = []
    var q1selected: Int = -1
    var q2: SKLabelNode = SKLabelNode(fontNamed: "ArialMT")
    var q2sol: [SKNode] = []
    var q2selected: Int = -1
    
    
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
    var TILEINDEX:Int = 0
    var STARTTIME:Double = 0.0
    var ENDTIME:Double = 0.0
    var TIME:Double = 0.0
    var DURATION:Double = 0.0
    var SESSIONID:Int = 0
    var INSTRUCTID:String = "0"
    var SCHOOLID:String = "0"
    var ETHNICID:String = "0"
    var SEXID:String = "0"
    var AGEID:String = "0"
    var GRADEID:String = "0"
    func API1(){
        // Prepare URL
        //change base URL to change databases
        // PROD: https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/session
        // STAGING: https://lk62rbimtg.execute-api.us-west-2.amazonaws.com/beta/session
        let endpoint1:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/session"
        guard let URL1 = URL(string: endpoint1) else {
            print("Error: Cannot create URL.")
            return
        }
        // Prepare URL Request Obj
        var URLRequest1 = URLRequest(url: URL1)
        URLRequest1.httpMethod = "POST"
        let newPost1 = ["body-json" : [
            "instructor_id": INSTRUCTID,
            "school_id": SCHOOLID,
            "ethnicity_id": ETHNICID,
            "sex": SEXID,
            "age": AGEID,
            "grade": GRADEID
        ]]
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
                    self.sessLabel.text = String(responseBody["id"] as! Int)
                } else {
                    print("Error: error in converting response body")
                }
            } else {
                print("Error: error in converting response data")
            }
        }
        task.resume()
    }
    func API2(){
        // Prepare URL
        // change base URL to change databases
        // PROD: https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/session
        // STAGING: https://lk62rbimtg.execute-api.us-west-2.amazonaws.com/beta/session
        let endpoint2:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/snapshot"
        guard let URL2 = URL(string: endpoint2) else {
            print("Error: Cannot create URL.")
            return
        }
        // Prepare URL Request Obj
        var URLRequest2 = URLRequest(url: URL2)
        URLRequest2.httpMethod = "POST"
        let newPost2 = ["body-json" : [
            "session_id": SESSIONID,
            "tile": TILEINDEX,
            "previous": tilePrev[TILEINDEX],
            "new": tileCurr[TILEINDEX],
            "duration": DURATION,
            "time_start": STARTTIME,
            "time_end": ENDTIME
        ]]
        // Creates JSoN
        let jsonPost2 = try? JSONSerialization.data(withJSONObject: newPost2, options: [])
        URLRequest2.httpBody = jsonPost2
        URLRequest2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest2){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post2")
                print(error ?? "No Data")
                return
            }
            // Parse responce
            let responseJSON2 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON2 as? [String: Any] {
                if (responseJSON["body"] as? [String: Any]) != nil {
                    print("Successful capture!")
                } else {
                    print("Error: error in converting response body")
                }
            } else {
                print("Error: error in converting response data")
            }
        }
        task.resume()
    }
    func API3(){
        // Prepare URL
        //change base URL to change databases
        // PROD: https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/session
        // STAGING: https://lk62rbimtg.execute-api.us-west-2.amazonaws.com/beta/session
        let endpoint3:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/school"
        guard let URL3 = URL(string: endpoint3) else {
            print("Error: Cannot create URL.")
            return
        }
        // Prepare URL Request Obj
        var URLRequest3 = URLRequest(url: URL3)
        URLRequest3.httpMethod = "GET"
        URLRequest3.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest3){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post3")
                print(error ?? "No Data")
                return
            }
            // Parse responce
            let responseJSON3 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON3 as? [String: Any] {
                if let responseBody = responseJSON["body"] as? [String: Any] {
                    self.school = responseBody["school_list"] as! [String]
                } else {
                    print("Error: error in converting response body")
                }
            } else {
                print("Error: error in converting response data")
            }
        }
        task.resume()
    }
    func API4(){
        // Prepare URL
        // change base URL to change databases
        // PROD: https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/session
        // STAGING: https://lk62rbimtg.execute-api.us-west-2.amazonaws.com/beta/session
        let endpoint4:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/questionnaire"
        guard let URL4 = URL(string: endpoint4) else {
            print("Error: Cannot create URL.")
            return
        }
        // Prepare URL Request Obj
        var URLRequest4 = URLRequest(url: URL4)
        URLRequest4.httpMethod = "POST"
        let newPost4 = ["body-json" : [
            "session_id": SESSIONID,
            "tile": TILEINDEX,
            "concept": tileCurr[TILEINDEX],
            "question_1": q1selected,
            "question_2": q2selected,
            "time": TIME
        ]]
        // Creates JSoN
        let jsonPost4 = try? JSONSerialization.data(withJSONObject: newPost4, options: [])
        URLRequest4.httpBody = jsonPost4
        URLRequest4.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest4){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post2")
                print(error ?? "No Data")
                return
            }
            // Parse responce
            let responseJSON4 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON4 as? [String: Any] {
                if (responseJSON["body"] as? [String: Any]) != nil {
                    print("Successful capture!")
                } else {
                    print("Error: error in converting response body")
                }
            } else {
                print("Error: error in converting response data")
            }
        }
        task.resume()
    }
    func API5(){
        // Prepare URL
        let endpoint5:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/session_remake"
        guard let URL5 = URL(string: endpoint5) else {
            print("Error: Cannot create URL.")
            spinLockAPI = false
            return
        }
        // Prepare URL Request Obj
        var URLRequest5 = URLRequest(url: URL5)
        URLRequest5.httpMethod = "POST"
        let newPost5 = ["body-json" : [
            "last_session": previousSessionField.text!
        ]]
        // Creates JSoN
        let jsonPost5 = try? JSONSerialization.data(withJSONObject: newPost5, options: [])
        URLRequest5.httpBody = jsonPost5
        URLRequest5.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest5){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post5")
                print(error ?? "No Data")
                self.spinLockAPI = false
                return
            }
            // Parse responce
            let responseJSON5 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON5 as? [String: Any] {
                if let responseBody = responseJSON["body"] as? [String: Any] {
                    self.SESSIONID = (responseBody["id"] as! Int)
                    self.sessLabel.text = String(responseBody["id"] as! Int)
                    self.sequenceApp = self.sequenceApp + 1
                    self.spinLockAPI = false
                } else {
                    print("Error: error in converting response body")
                    self.spinLockAPI = false
                }
            } else {
                print("Error: error in converting response data")
                self.spinLockAPI = false
            }
        }
        task.resume()
    }
    func API6(){
        // Prepare URL
        let endpoint6:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/stat_generate"
        guard let URL6 = URL(string: endpoint6) else {
            print("Error: Cannot create URL.")
            spinLockAPI = false
            return
        }
        // Prepare URL Request Obj
        var URLRequest6 = URLRequest(url: URL6)
        URLRequest6.httpMethod = "POST"
        let newPost6 = ["body-json" : [
            "session_id": SESSIONID
        ]]
        // Creates JSoN
        let jsonPost6 = try? JSONSerialization.data(withJSONObject: newPost6, options: [])
        URLRequest6.httpBody = jsonPost6
        URLRequest6.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest6){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post6")
                print(error ?? "No Data")
                self.spinLockAPI = false
                return
            }
            // Parse responce
            let responseJSON6 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON6 as? [String: Any] {
                if (responseJSON["body"] as? [String: Any]) != nil {
                    self.spinLockAPI = false
                } else {
                    print("Error: error in converting response body")
                    self.spinLockAPI = false
                }
            } else {
                print("Error: error in converting response data")
                self.spinLockAPI = false
            }
        }
        task.resume()
    }
    func API7(){
        // Prepare URL
        let endpoint7:String = "https://xj53w9d4z7.execute-api.us-east-2.amazonaws.com/default/stat_display"
        guard let URL7 = URL(string: endpoint7) else {
            print("Error: Cannot create URL.")
            spinLockAPI = false
            return
        }
        // Prepare URL Request Obj
        var URLRequest7 = URLRequest(url: URL7)
        URLRequest7.httpMethod = "POST"
        let newPost7 = ["body-json" : [
            "old_id": previousSessionField.text!,
            "new_id": SESSIONID
        ]]
        // Creates JSoN
        let jsonPost7 = try? JSONSerialization.data(withJSONObject: newPost7, options: [])
        URLRequest7.httpBody = jsonPost7
        URLRequest7.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Creates session
        let task = URLSession.shared.dataTask(with: URLRequest7){ data, response, error in
            guard let responseData = data, error == nil else {
                print("Error: error in calling Post7")
                print(error ?? "No Data")
                self.spinLockAPI = false
                return
            }
            // Parse responce
            let responseJSON7 = try? JSONSerialization.jsonObject(with: responseData, options: [])
            if let responseJSON = responseJSON7 as? [String: Any] {
                if let responseBody = responseJSON["body"] as? [String: Any] {
                    self.oldStats = responseBody["Old_Stats"] as! Array<Any>
                    self.newStats = responseBody["New_Stats"] as! Array<Any>
                    self.spinLockAPI = false
                } else {
                    print("Error: error in converting response body")
                    self.spinLockAPI = false
                }
            } else {
                print("Error: error in converting response data")
                self.spinLockAPI = false
            }
        }
        task.resume()
    }
    
    // Stat helper
    func buildStats() {
        for oldImg in oldStatImgs {
            if oldImg != nil {
                oldImg!.removeFromParent()
            }
        }
        for newImg in newStatImgs {
            if newImg != nil {
                newImg!.removeFromParent()
            }
        }
        for tile_label in stat_tile_labels {
            tile_label.text = ""
        }
        spinLockAPI = true
        API7()
        while spinLockAPI == true {
            sleep(1)
        }
        let num_pass_arr = [0, 2, 4, 6, 8, 10, 18, 20, 22]
        let tile_pass_arr = [0, 1, 2, 3, 4, 5, 9, 10, 11]
        for pass_num in 0...8 {
            if(!(oldStats[num_pass_arr[pass_num]] is NSNull)){
                oldStatImgs[tile_pass_arr[pass_num]] = SKSpriteNode(imageNamed: "TileSprite-\((oldStats[num_pass_arr[pass_num]] as! Int) + 1)")
                oldStatImgs[tile_pass_arr[pass_num]]!.size = spriteSize
                oldStatImgs[tile_pass_arr[pass_num]]!.position = spritePos
                oldStatImgs[tile_pass_arr[pass_num]]!.zPosition = 1
                stat_tiles[tile_pass_arr[pass_num] + 18].addChild(oldStatImgs[tile_pass_arr[pass_num]]!)
                stat_tile_labels[tile_pass_arr[pass_num] + 18].text = "\(String(format: "%.2f", (oldStats[num_pass_arr[pass_num] + 1] as! NSNumber).floatValue))s"
            }
            if(!(newStats[num_pass_arr[pass_num]] is NSNull)){
                newStatImgs[tile_pass_arr[pass_num]] = SKSpriteNode(imageNamed: "TileSprite-\((newStats[num_pass_arr[pass_num]] as! Int) + 1)")
                newStatImgs[tile_pass_arr[pass_num]]!.size = spriteSize
                newStatImgs[tile_pass_arr[pass_num]]!.position = spritePos
                newStatImgs[tile_pass_arr[pass_num]]!.zPosition = 1
                stat_tiles[tile_pass_arr[pass_num]].addChild(newStatImgs[tile_pass_arr[pass_num]]!)
                stat_tile_labels[tile_pass_arr[pass_num]].text = "\(String(format: "%.2f", (newStats[num_pass_arr[pass_num] + 1] as! NSNumber).floatValue))s"
            }
        }
        let num_pass_arr_2 = [12, 14, 16]
        let tile_pass_arr_2 = [6, 7, 8]
        for pass_num_2 in 0...2 {
            if(!(oldStats[num_pass_arr_2[pass_num_2]] is NSNull)){
                oldStatImgs[tile_pass_arr_2[pass_num_2]] = SKSpriteNode(imageNamed: "TileSprite-\((oldStats[num_pass_arr_2[pass_num_2]] as! Int) + 1)")
                oldStatImgs[tile_pass_arr_2[pass_num_2]]!.size = spriteSize
                oldStatImgs[tile_pass_arr_2[pass_num_2]]!.position = spritePos
                oldStatImgs[tile_pass_arr_2[pass_num_2]]!.zPosition = 1
                stat_tiles[tile_pass_arr_2[pass_num_2] + 18].addChild(oldStatImgs[tile_pass_arr_2[pass_num_2]]!)
                stat_tile_labels[tile_pass_arr_2[pass_num_2] + 18].text = "\(String(format: "%.0f", (oldStats[num_pass_arr_2[pass_num_2] + 1] as! NSNumber).floatValue))"
            }
            if(!(newStats[num_pass_arr_2[pass_num_2]] is NSNull)){
                newStatImgs[tile_pass_arr_2[pass_num_2]] = SKSpriteNode(imageNamed: "TileSprite-\((newStats[num_pass_arr_2[pass_num_2]] as! Int) + 1)")
                newStatImgs[tile_pass_arr_2[pass_num_2]]!.size = spriteSize
                newStatImgs[tile_pass_arr_2[pass_num_2]]!.position = spritePos
                newStatImgs[tile_pass_arr_2[pass_num_2]]!.zPosition = 1
                stat_tiles[tile_pass_arr_2[pass_num_2]].addChild(newStatImgs[tile_pass_arr_2[pass_num_2]]!)
                stat_tile_labels[tile_pass_arr_2[pass_num_2]].text = "\(String(format: "%.0f", (newStats[num_pass_arr_2[pass_num_2] + 1] as! NSNumber).floatValue))"
            }
        }
        for pass_num_3 in 12...17 {
            if(!(oldStats[pass_num_3 + 12] is NSNull)){
                oldStatImgs[pass_num_3] = SKSpriteNode(imageNamed: "TileSprite-\((oldStats[pass_num_3 + 12] as! Int) + 1)")
                oldStatImgs[pass_num_3]!.size = spriteSize
                oldStatImgs[pass_num_3]!.position = spritePos
                oldStatImgs[pass_num_3]!.zPosition = 1
                stat_tiles[pass_num_3 + 18].addChild(oldStatImgs[pass_num_3]!)
            }
            if(!(newStats[pass_num_3 + 12] is NSNull)){
                newStatImgs[pass_num_3] = SKSpriteNode(imageNamed: "TileSprite-\((newStats[pass_num_3 + 12] as! Int) + 1)")
                newStatImgs[pass_num_3]!.size = spriteSize
                newStatImgs[pass_num_3]!.position = spritePos
                newStatImgs[pass_num_3]!.zPosition = 1
                stat_tiles[pass_num_3].addChild(newStatImgs[pass_num_3]!)
            }
        }
        if SESSIONID != 0 {
            stat_label_1.text = "Session \(SESSIONID)"
        } else {
            stat_label_1.text = ""
        }
        if previousSessionField.text! != "" {
            stat_label_2.text = "Session \(previousSessionField.text!)"
        } else {
            stat_label_2.text = ""
        }
    }
    
    // Question helper
    func setTileHistory(node:SKShapeNode, text:String){
        tileIndex = tiles.firstIndex(of: node)
        tilePrev[tileIndex!] = tileCurr[tileIndex!]
        tileCurr[tileIndex!] = text
        questionPrompt1.text = "I see you’re saying \(tile_labels[tileIndex].name!) is somehow related to \(tileCurr[tileIndex]). Please answer the following questions."
        questionPrompt1.numberOfLines = 2
        questionPrompt1.preferredMaxLayoutWidth = questionPrompt1.parent!.frame.width * 0.95
        let qSolution_Template = SKLabelNode(fontNamed: "ArialMT")
        qSolution_Template.fontColor = SKColor.black
        qSolution_Template.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        qSolution_Template.position = CGPoint(x: 0, y: 0)
        qSolution_Template.fontSize = 18 * ratio
        qSolution_Template.zPosition = 1
        // begin the shit show lmfao
        for parent in (q1sol + q2sol) {
            parent.removeAllChildren()
        }
        let q1sol0 = qSolution_Template.copy() as! SKLabelNode
        q1sol0.text = "\(tile_labels[tileIndex].name!) affects \(tileCurr[tileIndex]) more."
        q1sol[0].addChild(q1sol0)
        let q1sol1 = qSolution_Template.copy() as! SKLabelNode
        q1sol1.text = "\(tileCurr[tileIndex]) affects \(tile_labels[tileIndex].name!) more."
        q1sol[1].addChild(q1sol1)
        let q1sol2 = qSolution_Template.copy() as! SKLabelNode
        q1sol2.text = "These two concepts affect each other about the same."
        q1sol[2].addChild(q1sol2)
        let q1sol3 = qSolution_Template.copy() as! SKLabelNode
        q1sol3.text = "None of these choices work for me."
        q1sol[3].addChild(q1sol3)
        let q1sol4 = qSolution_Template.copy() as! SKLabelNode
        q1sol4.text = "I don’t know."
        q1sol[4].addChild(q1sol4)
        let q2sol0 = qSolution_Template.copy() as! SKLabelNode
        q2sol0.text = "I am NOT sure."
        q2sol[0].addChild(q2sol0)
        let q2sol1 = qSolution_Template.copy() as! SKLabelNode
        q2sol1.text = "I am SOMEWHAT sure."
        q2sol[1].addChild(q2sol1)
        let q2sol2 = qSolution_Template.copy() as! SKLabelNode
        q2sol2.text = "I AM sure."
        q2sol[2].addChild(q2sol2)
        let q2sol3 = qSolution_Template.copy() as! SKLabelNode
        q2sol3.text = "None of these choices work for me."
        q2sol[3].addChild(q2sol3)
        let q2sol4 = qSolution_Template.copy() as! SKLabelNode
        q2sol4.text = "I don’t know."
        q2sol[4].addChild(q2sol4)
        let selectBubble_template = SKShapeNode(circleOfRadius: passScreen.frame.width/100)
        selectBubble_template.strokeColor = SKColor.black
        selectBubble_template.lineWidth = (ratio * 2)
        selectBubble_template.fillColor = SKColor.white
        selectBubble_template.position.x = ratio * (-15)
        selectBubble_template.position.y = ratio * (8)
        for option in (q1sol + q2sol) {
            let selectBubble = selectBubble_template.copy() as! SKShapeNode
            selectBubble.name = "select"
            option.addChild(selectBubble)
        }
    }
    
    // API and State Validators
    func validate1(){
        // Validate submit info and then send to SQL server
        // Then set up game
        if previousSessionField.text == "" || previousSessionField.text == nil {
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
            SCHOOLID = "\(school.firstIndex(of: textFields[0].text!)!)"
            form.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
            for i in 0...4 {
                textFields[i].isHidden = true
                pickers[i].isHidden = true
            }
            previousSessionField.isHidden = true
            API1()
            sequenceApp = sequenceApp + 1
        } else {
            spinLockAPI = true
            API5()
            while spinLockAPI == true {
                sleep(1)
            }
            if sequenceApp == 2 {
                form.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
                for i in 0...4 {
                    textFields[i].isHidden = true
                    pickers[i].isHidden = true
                }
                previousSessionField.isHidden = true
            }
        }
    }
    func validate2(node:SKShapeNode){
        // Validate submit info and then send to SQL server
        TILEINDEX = tiles.firstIndex(of: node) ?? -1
        currTime = NSDate()
        STARTTIME = clickTime.timeIntervalSince(startTime as Date)
        ENDTIME = currTime.timeIntervalSince(startTime as Date)
        DURATION = currTime.timeIntervalSince(clickTime as Date)
        if (TILEINDEX != -1) {
            API2()
        }
    }
    
    func stepForward1(){
        passScreen.run(SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: 0.3))
        passScreen.zPosition = zPosUpdater + 2
        contBtn.run(SKAction.fadeAlpha(to: 0, duration: 0))
        sequenceApp = sequenceApp + 1
    }
    func stepForward2(){
        passScreen.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        passScreen.zPosition = zPosUpdater + 2
        sequenceApp = sequenceApp + 1
        if submitLabel.text == "SUBMIT" {
            submitLabel.text = "FINISH"
        } else {
            submitLabel.text = "SUBMIT"
        }
        if sequenceApp == 4 {
            spinLockAPI = true
            API6()
            while spinLockAPI == true {
                sleep(1)
            }
            statScreen.run(SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: 0.3))
            statScreen.zPosition = zPosUpdater + 2
            buildStats()
            sequenceApp = 4
        }
        if sequenceApp == 7 {
            stepBackward2()
        }
    }
    func stepForward3(){
        statScreen.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        statScreen.zPosition = zPosUpdater + 2
        sequenceApp = sequenceApp + 1
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
        previousSessionField.text = ""
        previousSessionField.isHidden = false
        sessLabel.text = "Null"
        resetCounter = 0
        tileBankTranslator.shuffle()
        for tile in tiles {
            tile.run(SKAction.move(by: CGVector(dx: tileBankLocDict[tileBankTranslator[resetCounter]].x - (tile.position.x), dy: tileBankLocDict[tileBankTranslator[resetCounter]].y - (tile.position.y)), duration: 0.3))
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
        for i in 0...14 {
            tileCurr[i] = "Bank"
            tilePrev[i] = "Bank"
        }
        remainingInBank = 15
        sequenceApp = 1
        for i in 0...4{
            textFields[i].text = nil
        }
    }
    func questionaire1(node:SKShapeNode){
        let tileIndex = tiles.firstIndex(of: node)
        if tilePrev[tileIndex!] == tileCurr[tileIndex!]{
            return
        }
        questionState = true
        questionForm.run(SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: 0.3))
        questionForm.zPosition = zPosUpdater + 2
    }
    func questionaire2(){
        questionForm.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
        currTime = NSDate()
        TIME = currTime.timeIntervalSince(startTime as Date)
        API4()
        questionState = false
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
        if questionState == true {
            followDisable = true
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if q1sol.contains(node.parent ?? node) {
                        for option in q1sol {
                            let castedOption = option.childNode(withName: "select") as! SKShapeNode
                            castedOption.fillColor = SKColor.white
                        }
                        let castedOption = (node.childNode(withName: "select") ?? node.parent?.childNode(withName: "select")) as! SKShapeNode
                        q1selected = q1sol.firstIndex(of: castedOption.parent!)!
                        castedOption.fillColor = SKColor.systemBlue
                    } else if q2sol.contains(node.parent ?? node) {
                        for option in q2sol {
                            let castedOption = option.childNode(withName: "select") as! SKShapeNode
                            castedOption.fillColor = SKColor.white
                        }
                        let castedOption = (node.childNode(withName: "select") ?? node.parent?.childNode(withName: "select")) as! SKShapeNode
                        q2selected = q2sol.firstIndex(of: castedOption.parent!)!
                        castedOption.fillColor = SKColor.systemBlue
                    } else if (node.name == "questionBtn" && !node.hasActions()) {
                        if (q1selected == -1 || q2selected == -1){
                            break
                        }
                        questionaire2()
                        q1selected = -1
                        q2selected = -1
                        for option in (q1sol + q2sol) {
                            let theNodeToBeCast = option.childNode(withName: "select") ?? option.childNode(withName: "selectFilled")
                            let castedOption = theNodeToBeCast as! SKShapeNode
                            castedOption.name = "select"
                            castedOption.fillColor = SKColor.white
                        }
                        break
                    }
                }
            }
        } else if sequenceApp == 1 {
            followDisable = true
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if node.name == "loginBtn" && !node.hasActions(){
                        validate1()
                        startTime = NSDate()
                        clickTime = NSDate()
                        break
                    }
                }
            }
        } else if (sequenceApp == 2) || (sequenceApp == 5) {
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
                    clickTime = NSDate()
                }
            }
        } else if (sequenceApp == 3) || (sequenceApp == 6) {
            followDisable = true
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if node.name == "contBtn" && !node.hasActions(){
                        attempt = 0
                        for bubble in numAttempt {
                            bubble.fillColor = SKColor.white
                        }
                        stepForward2()
                        spinLockState = 0
                        break
                    } else if node.name == "pass" {
                        break
                    } else if numButtons.contains(node) || numButtons.contains(node.parent ?? node){
                        if attempt == 4 {
                            break
                        }
                        if (node.name == "numPad0" || node.parent!.name == "numPad0") && spinLockState == 3 {
                            numAttempt[attempt].fillColor = SKColor.systemBlue
                            attempt = attempt + 1
                            spinLockState = 4
                            contBtn.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                            break
                        } else if (node.name == "numPad1" || node.parent!.name == "numPad1") && spinLockState == 2 {
                            numAttempt[attempt].fillColor = SKColor.systemBlue
                            attempt = attempt + 1
                            spinLockState = 3
                            break
                        } else if (node.name == "numPad2" || node.parent!.name == "numPad2") && spinLockState == 1 {
                            numAttempt[attempt].fillColor = SKColor.systemBlue
                            attempt = attempt + 1
                            spinLockState = 2
                            break
                        } else if (node.name == "numPad3" || node.parent!.name == "numPad3") && attempt == 0 {
                            numAttempt[attempt].fillColor = SKColor.systemBlue
                            attempt = attempt + 1
                            spinLockState = 1
                            break
                        } else {
                            numAttempt[attempt].fillColor = SKColor.systemBlue
                            attempt = attempt + 1
                            if attempt == 4 {
                                attempt = 0
                                for bubble in numAttempt {
                                    bubble.fillColor = SKColor.white
                                }
                            }
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
        } else if (sequenceApp == 4) {
            followDisable = true
            for touch in touches {
                let location = touch.location(in: self)
                // Creates list of nodes sorted by Z-value at touch location
                let touchedNode = self.nodes(at: location)
                // Checks for first 'tile' node
                for node in touchedNode {
                    if node.name == "statBtn" && !node.hasActions(){
                        stepForward3()
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
                                castedNode.fillColor = SKColor(red: 1/2, green: 143/255, blue: 1, alpha: 1)
                                break
                            } else if (node.name == "w_space") && (distance(location, p2) < circleWidth / 2) {
                                castedNode.fillColor = SKColor(red: 1, green: 143/255, blue: 1/2, alpha: 1)
                                break
                            } else if (node.name == "e_space") && (distance(location, p3) < circleWidth / 2) {
                                castedNode.fillColor = SKColor(red: 1/2, green: 215/255, blue: 1/2, alpha: 1)
                                break
                            }
                        } else if node.name == "cwe_space" && (location.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) {
                            castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                            break
                        } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                            if node.name == "cw_space" {
                                castedNode.fillColor = SKColor(red: 1, green: 159/255, blue: 1, alpha: 1)
                                break
                            } else if node.name == "we_space" && (location.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (location.x - weBar[0].x) + weBar[0].y)) && (location.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (location.x - weBar[3].x) + weBar[3].y)) {
                                castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1/2, alpha: 1)
                                break
                            } else if node.name == "ce_space" && (location.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (location.x - ceBar[3].x) + ceBar[3].y)) && (location.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (location.x - ceBar[0].x) + ceBar[0].y)) {
                                castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1, alpha: 1)
                                break
                            }
                        } else if node.name == "na_space" {
                            castedNode.fillColor = SKColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
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
                                castedNode.fillColor = SKColor(red: 1/2, green: 143/255, blue: 1, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                setTileHistory(node: castedNode, text: "Climate")
                                questionaire1(node: castedNode)
                                break
                            } else if (node.name == "w_space") && (distance(locationEnd, p2) < circleWidth / 2) {
                                castedNode.fillColor = SKColor(red: 1, green: 143/255, blue: 1/2, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                setTileHistory(node: castedNode, text: "Weather")
                                questionaire1(node: castedNode)
                                break
                            } else if (node.name == "e_space") && (distance(locationEnd, p3) < circleWidth / 2) {
                                castedNode.fillColor = SKColor(red: 1/2, green: 215/255, blue: 1/2, alpha: 1)
                                nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                                nodeFound = true
                                setTileHistory(node: castedNode, text: "Environment")
                                questionaire1(node: castedNode)
                                break
                            }
                        } else if node.name == "cwe_space" && (locationEnd.y > (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                            nodeFound = true
                            setTileHistory(node: castedNode, text: "Climate, Weather, & Environment")
                            questionaire1(node: castedNode)
                            break
                        } else if node.name == "cw_space" || node.name == "we_space" || node.name == "ce_space" {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            nodeFound = true
                            if node.name == "cw_space" {
                                castedNode.fillColor = SKColor(red: 1, green: 159/255, blue: 1, alpha: 1)
                                setTileHistory(node: castedNode, text: "Climate & Weather")
                                questionaire1(node: castedNode)
                                break
                            } else if node.name == "we_space" && (locationEnd.y > (((weBar[1].y - weBar[0].y)/(weBar[1].x - weBar[0].x)) * (locationEnd.x - weBar[0].x) + weBar[0].y)) && (locationEnd.y < (((weBar[2].y - weBar[3].y)/(weBar[2].x - weBar[3].x)) * (locationEnd.x - weBar[3].x) + weBar[3].y)) {
                                nodeToMove.run(SKAction.rotate(byAngle: (CGFloat.pi/3), duration: 0.2))
                                castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1/2, alpha: 1)
                                setTileHistory(node: castedNode, text: "Weather & Environment")
                                questionaire1(node: castedNode)
                                break
                            } else if node.name == "ce_space" && (locationEnd.y > (((ceBar[2].y - ceBar[3].y)/(ceBar[2].x - ceBar[3].x)) * (locationEnd.x - ceBar[3].x) + ceBar[3].y)) && (locationEnd.y < (((ceBar[1].y - ceBar[0].y)/(ceBar[1].x - ceBar[0].x)) * (locationEnd.x - ceBar[0].x) + ceBar[0].y)) {
                                nodeToMove.run(SKAction.rotate(byAngle: -(CGFloat.pi/3), duration: 0.2))
                                castedNode.fillColor = SKColor(red: 1/2, green: 1, blue: 1, alpha: 1)
                                setTileHistory(node: castedNode, text: "Climate & Environment")
                                questionaire1(node: castedNode)
                                break
                            }
                        } else if node.name == "na_space" {
                            nodeToMove.run(SKAction.scale(to: 0.8, duration: 0.2))
                            castedNode.fillColor = SKColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
                            nodeFound = true
                            setTileHistory(node: castedNode, text: "I don’t know")
                            //questionaire1(node: castedNode)
                            break
                        }
                    }
                    // If retruning tile to bank location
                    if !nodeFound {
                        // Returns tile to it's proper bank location
                        dictLookup = (tiles.firstIndex(of: castedNode) ?? 0)
                        nodeToMove.run(SKAction.move(by: CGVector(dx: tileBankLocDict[tileBankTranslator[dictLookup]].x - (nodeToMove.position.x), dy: tileBankLocDict[tileBankTranslator[dictLookup]].y - (nodeToMove.position.y)), duration: 0.3))
                        castedNode.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
                        // Returns tile to normal side
                        nodeToMove.run(SKAction.scale(to: 1, duration: 0.2))
                        // Updates bank count
                        remainingInBank = remainingInBank + 1
                        // Hides submit if submit is a tile is selected
                        if remainingInBank == 1 {
                            submit.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                        }
                        setTileHistory(node: castedNode, text: "Bank")
                        //questionaire1(node: castedNode)
                    }
                }
                // Displays submit if bank is empty
                if makeSumbitVis && remainingInBank == 0 {
                    submit.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                    makeSumbitVis = false
                }
                locationOld = nil
                nodeToMove = nil
                validate2(node: castedNode)
            }
        }
    }
    
    private func initializeMenu() {
        tileBankTranslator.shuffle()
        API3()
        while (school.count) == 1 {
            sleep(1)
        }
        // THE NEXT 80 lines are just dog shit code design. Good luck.
        // setting array for stats
        oldStatImgs = [oldStat1img, oldStat2img, oldStat3img, oldStat4img, oldStat5img, oldStat6img, oldStat7img, oldStat8img, oldStat9img, oldStat10img, oldStat11img, oldStat12img, oldStat13img, oldStat14img, oldStat15img, oldStat16img, oldStat17img, oldStat18img]
        newStatImgs = [newStat1img, newStat2img, newStat3img, newStat4img, newStat5img, newStat6img, newStat7img, newStat8img, newStat9img, newStat10img, newStat11img, newStat12img, newStat13img, newStat14img, newStat15img, newStat16img, newStat17img, newStat18img]
        // Declaring constants to determine object sizing
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        gameBG = SKShapeNode()
        self.addChild(gameBG)
        // Determines screen ratio to maintain constant size
        ratio = (screenWidth / CGFloat(850))
        let ratioLocal: CGFloat = (screenWidth / CGFloat(850))
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
        let naSpace: [CGPoint] = [CGPoint(x: -(halfScreenWidth) - (4 * ratioLocal), y: midMargin + bottomMargin + (0.6 * circleWidth)), CGPoint(x: -(halfScreenWidth) - (4 * ratioLocal), y: (screenHeight / -2) - (4 * ratioLocal)), CGPoint(x: halfScreenWidth + (4 * ratioLocal), y: (screenHeight / -2) - (4 * ratioLocal)), CGPoint(x: halfScreenWidth + (4 * ratioLocal), y: midMargin + bottomMargin + (0.6 * circleWidth))]
        path5.addLines(between: [naSpace[0], naSpace[1], naSpace[2], naSpace[3], naSpace[0]])
        naBG.path = path5
        naBG.fillColor = SKColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
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
        cwBG.fillColor = SKColor(red: 1, green: 63/255, blue: 1, alpha: 1)
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
        ceBG.fillColor = SKColor(red: 0, green: 1, blue: 1, alpha: 1)
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
        weBG.fillColor = SKColor(red: 1, green: 1, blue: 0, alpha: 1)
        weBG.strokeColor = SKColor.black
        weBG.lineWidth = 4 * ratio
        weBG.name = "we_space"
        gameBG.addChild(weBG)
        let gameBarList = [ceBG, cwBG, weBG]
        // Create Climate, Weather, and Environment Circle
        var BG_circles:[SKShapeNode] = []
        let BG_circle_template = SKShapeNode.init(circleOfRadius: (circleWidth / 2))
        BG_circle_template.zPosition = 4
        BG_circle_template.strokeColor = SKColor.black
        BG_circle_template.lineWidth = 4 * ratio
        let BG_cicle_pos = [p1, p2, p3]
        let BG_cicle_color = [SKColor(red: 0, green: 31/255, blue: 1, alpha: 1), SKColor(red: 1, green: 31/255, blue: 0, alpha: 1), SKColor(red: 0, green: 175/255, blue: 0, alpha: 1)]
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
        bankLabel.text = "Drag sub-concepts to base map below."
        bankLabel.fontSize = 40 * ratio
        bankLabel.zPosition = 2
        bankLabel.position = CGPoint(x: naBG.frame.midX, y: naBG.frame.maxY + (25 * ratio))
        bankLabel.fontColor = SKColor.black
        gameBG.addChild(bankLabel)
        // Create session label
        sessLabel = SKLabelNode(fontNamed: "ArialMT")
        sessLabel.text = "Null"
        sessLabel.fontSize = 15 * ratio
        sessLabel.zPosition = 2
        sessLabel.position = CGPoint(x: (35 * ratio) - (screenWidth / 2), y: (20 * ratio) - (screenHeight / 2))
        sessLabel.fontColor = SKColor.black
        gameBG.addChild(sessLabel)
        // Create Immobile Circle Labels
        let circleLabelText = ["Climate", "Weather", "Environment"]
        for i in 0...2 {
            let cicleLabel = SKLabelNode(fontNamed: "ArialMT")
            cicleLabel.fontSize = 45 * ratio
            cicleLabel.position = CGPoint(x: BG_circles[i].frame.midX, y: BG_circles[i].frame.midY - (cicleLabel.fontSize / 2))
            cicleLabel.zPosition = 5
            cicleLabel.text = circleLabelText[i]
            gameBG.addChild(cicleLabel)
        }
        // Create Immobile Bar Labels
        let rotation1 = -60 * CGFloat.pi / 180
        let rotation2 = 60 * CGFloat.pi / 180
        let barLabelRotation = [rotation1, rotation1, 0, 0, rotation2, rotation2]
        let barLabelText = ["Climate &", "Environment", "Climate &", "Weather", "Environment", "& Weather"]
        let barLabelOriginX = [6 * ratio * CGFloat(3).squareRoot(), -15 * ratio * CGFloat(3).squareRoot(), 0, 0, -6 * ratio * CGFloat(3).squareRoot(), 15 * ratio * CGFloat(3).squareRoot()]
        let barLabelOriginY = [6 * ratioLocal, -15 * ratioLocal, 6 * ratioLocal, -36 * ratioLocal, 6 * ratioLocal, -15 * ratioLocal]
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
        let cweLabelsText = ["Environment &", "Weather &", "Climate"]
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
            naLabel.text = "I don’t know"
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
        while y_pos_iter >= (tileMin) + (tileHeight / 2) {
            while x_pos_iter <= tileOffsetX + (2 * tileBufferX) + (tileLength / 2){
                tileBankLocDict.append(CGPoint(x:x_pos_iter, y:y_pos_iter))
                x_pos_iter += tileBufferX
            }
            y_pos_iter += (tileMin - tileMax) / 4
            x_pos_iter = tileOffsetX - (2 * tileBufferX) + (tileLength / 2)
        }
        // same thing for stats
        stat_tileBankLocDict = []
        let statTileMin = bottomMargin + midMargin + circleWidth
        x_pos_iter = (tileOffsetX - (2 * tileLength)) * 0.87
        y_pos_iter = statTileMin + 1.74*tileHeight
        while x_pos_iter <= tileOffsetX + (2 * tileBufferX) + (tileLength / 2){
            while y_pos_iter >= (statTileMin) {
                stat_tileBankLocDict.append(CGPoint(x:x_pos_iter, y:y_pos_iter))
                y_pos_iter -= tileHeight * 0.87
            }
            x_pos_iter += tileLength * 0.87
            y_pos_iter = statTileMin + 1.74*tileHeight
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
        // Creates template for the tile static color // DEPRICATED
        // Create Sprite constants
        let temporaryValue1 = ((tileHeight - (2 * ratio)) - tileLength)
        let spriteOffset = (temporaryValue1 / 2) + (3 * ratio)
        spritePos = CGPoint(x: spriteOffset, y: 0)
        spriteSize = CGSize(width: tileHeight - (2 * ratio), height: tileHeight - (2 * ratio))
        // Labels and associated position for tiles
        let tile_labelsText = ["Cooling\n temps ", "Warming\n  temps ", "   Fast \nchanges", "  Yearly\nchanges", "   Slow \nchanges", "Farming", "Industry", "Local\n area", "Regional\n   area", "Global\n  area", "Animals\n& plants", "People", "Forests", "Oceans", "Greenhouse\n      effect "]
        let tile_labelsName = ["Cooling Temps", "Warming Temps", "Fast Changes", "Yearly Changes", "Slow Changes", "Farming", "Industry", "Local area", "Regional area", "Global area", "Animals & Plants", "People", "Forests", "Oceans", "Greenhouse Effect"]
        // Assign tile properties, append to game board as children
        for i in 0...14 {
            //tile
            let tile = tile_shape.copy() as! SKShapeNode
            tile.position = tileBankLocDict[tileBankTranslator[i]]
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
        questionBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height*0.28,width:self.size.width/2,height:50), fillColor:SKColor.blue, title:"Continue", logo:nil, name:"questionBtn")
        questionBtn.zPosition = 1
        questionForm.addChild(questionBtn)
        passScreen = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        passScreen.name = "pass"
        statScreen = SKShapeNode.init(rect: CGRect(x: -(screenWidth*0.9 / 2), y: -(screenHeight*0.5 / 2), width: screenWidth*0.9, height: screenHeight*0.7), cornerRadius: 15)
        statScreen.name = "statScreen"
        let formCrew = [form, questionForm, passScreen, statScreen]
        for forms in formCrew {
            forms!.fillColor = SKColor.white
            forms!.strokeColor = SKColor.black
            forms!.zPosition = 8000
            self.addChild(forms!)
            if forms! != form {
                forms!.run(SKAction.moveBy(x: 0, y: UIScreen.main.bounds.height, duration: 0.3))
            }
        }
        // Creates question headers
        questionPrompt1.zPosition = 1
        questionPrompt1.fontColor = SKColor.black
        questionPrompt1.fontSize = 25 * ratio
        questionPrompt1.position = CGPoint(x: 0, y: questionForm.frame.maxY - 90 * ratio)
        questionForm.addChild(questionPrompt1)
        // Creates question prompts
        q1.text = "Which way(s) do you think this relationship goes?"
        q2.text = "How sure are you about your thinking about this relationship?"
        let qList = [q1, q2]
        for i in 0...1{
            qList[i].fontColor = SKColor.black
            qList[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            let tempXvar = questionForm.frame.minX + 60 * ratio
            let tempYvar1 = 150 * ratio
            var tempYvar2 = CGFloat(i) * 180 * ratio
            tempYvar2 = tempYvar2 + 25 * ratio
            qList[i].position = CGPoint(x: tempXvar, y: questionForm.frame.maxY - (tempYvar1 + tempYvar2))
            qList[i].fontSize = 18 * ratio
            qList[i].zPosition = 1
            questionForm.addChild(qList[i])
            for j in 1...5{
                tempYvar2 = CGFloat(i) * 180 * ratio + CGFloat(j + 1) * 25 * ratio
                let questionSol = SKShapeNode.init(rect: CGRect(x: 0, y: 0, width: self.size.width*0.7, height: 20))
                questionSol.position = CGPoint(x: -self.size.width*0.35, y: questionForm.frame.maxY - (tempYvar1 + tempYvar2))
                questionSol.fillColor = SKColor.white
                if i == 0 {
                    q1sol.append(questionSol)
                } else if i == 1 {
                    q2sol.append(questionSol)
                }
                questionForm.addChild(questionSol)
            }
        }
        // Creates numberpad for password screen
        let numPadAttemptBubble_template = SKShapeNode(circleOfRadius: passScreen.frame.width/60)
        numPadAttemptBubble_template.strokeColor = SKColor.black
        numPadAttemptBubble_template.lineWidth = (ratio * 2)
        numPadAttemptBubble_template.fillColor = SKColor.white
        numAttempt = []
        for i in 0...3 {
            let numPadAttemptBubble = numPadAttemptBubble_template.copy() as! SKShapeNode
            numPadAttemptBubble.name = "numPadTry\(i)"
            numPadAttemptBubble.position.x = (CGFloat(i) - CGFloat(1.5)) * screenWidth * 0.096
            numPadAttemptBubble.position.y = 2.2 * (4) * screenWidth * 0.9/15
            numAttempt.append(numPadAttemptBubble)
            passScreen.addChild(numPadAttemptBubble)
        }
        let numPad_template = SKShapeNode(circleOfRadius: passScreen.frame.width/15)
        numPad_template.fillColor = SKColor.lightGray
        numPad_template.zPosition = 1
        numButtons = []
        let numPadtxt_template = SKLabelNode(fontNamed: "ArialMT")
        numPadtxt_template.zPosition = 0
        numPadtxt_template.fontSize = 45 * ratio
        numPadtxt_template.position = CGPoint(x: 0, y: (-numPadtxt_template.frame.height / 2) - (18 * ratio))
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
        contBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height/4,width:self.size.width/2,height:50), fillColor:SKColor.blue, title:"Continue Session", logo:nil, name:"contBtn")
        contBtn.zPosition = 1
        passScreen.addChild(contBtn)
        // Stat tiles
        for i in 0...17 {
            //tile
            let tile = tile_shape.copy() as! SKShapeNode
            tile.position = stat_tileBankLocDict[i]
            tile.run(SKAction.scale(to: 0.87, duration: 0))
            stat_tiles.append(tile)
            statScreen.addChild(tile)
            let tile_label = tile_label_teplate.copy() as! SKLabelNode
            tile_label.text = ""
            tile_label.numberOfLines = 3
            tile_label.preferredMaxLayoutWidth = tileLengthOriginal
            stat_tile_labels.append(tile_label)
            tile.addChild(tile_label)
        }
        for i in 0...17 {
            //tile
            let tile = tile_shape.copy() as! SKShapeNode
            tile.position = CGPoint(x: stat_tileBankLocDict[i].x, y: stat_tileBankLocDict[i].y - (screenHeight / 6))
            tile.run(SKAction.scale(to: 0.87, duration: 0))
            stat_tiles.append(tile)
            statScreen.addChild(tile)
            let tile_label = tile_label_teplate.copy() as! SKLabelNode
            tile_label.text = ""
            tile_label.numberOfLines = 3
            tile_label.preferredMaxLayoutWidth = tileLengthOriginal
            stat_tile_labels.append(tile_label)
            tile.addChild(tile_label)
        }
        let tile_shape_stat = SKShapeNode.init(rect: CGRect(x: -(tileLength / 2), y: -(tileHeight / 4), width: tileLength, height: tileHeight / 2))
        tile_shape_stat.name = "tile"
        tile_shape_stat.fillColor = SKColor.gray
        tile_shape_stat.strokeColor = SKColor.black
        tile_shape_stat.lineWidth = 2 * ratio
        tile_shape_stat.zPosition = 6
        let tile_label_teplate_stat = SKLabelNode(fontNamed: "ArialMT")
        tile_label_teplate_stat.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tile_label_teplate_stat.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tile_label_teplate_stat.fontSize = tileLengthOriginal / 5
        tile_label_teplate.position = CGPoint(x: 0, y: 0)
        tile_label_teplate_stat.fontColor = SKColor.white
        tile_label_teplate_stat.zPosition = 2
        let header_labels = ["Last","Slowest",">1 Placement","Pause","Direction", "Unsureness"]
        for i in 0...5 {
            let tile1 = tile_shape_stat.copy() as! SKShapeNode
            tile1.position = CGPoint(x: stat_tileBankLocDict[i*3].x, y: stat_tileBankLocDict[i*3].y - (screenHeight / 6) + tileHeight * 0.6525)
            tile1.run(SKAction.scale(to: 0.87, duration: 0))
            statScreen.addChild(tile1)
            let tile2 = tile_shape_stat.copy() as! SKShapeNode
            tile2.position = CGPoint(x: stat_tileBankLocDict[i*3].x, y: stat_tileBankLocDict[i*3].y + tileHeight * 0.6525)
            tile2.run(SKAction.scale(to: 0.87, duration: 0))
            statScreen.addChild(tile2)
            let header_label = tile_label_teplate_stat.copy() as! SKLabelNode
            header_label.text = header_labels[i]
            header_label.numberOfLines = 1
            header_label.preferredMaxLayoutWidth = tileLengthOriginal
            let header_label_2 = header_label.copy() as! SKLabelNode
            tile1.addChild(header_label)
            tile2.addChild(header_label_2)
        }
        stat_label_1 = tile_label_teplate_stat.copy() as? SKLabelNode
        stat_label_1.position = CGPoint(x: stat_tileBankLocDict[0].x, y: stat_tileBankLocDict[0].y + tileHeight * 1.1)
        stat_label_1.fontColor = SKColor.black
        stat_label_1.run(SKAction.scale(to: 0.87, duration: 0))
        statScreen.addChild(stat_label_1)
        stat_label_2 = tile_label_teplate_stat.copy() as? SKLabelNode
        stat_label_2.position = CGPoint(x: stat_tileBankLocDict[0].x, y: stat_tileBankLocDict[0].y - (screenHeight / 6) + tileHeight * 1.1)
        stat_label_2.fontColor = SKColor.black
        stat_label_2.run(SKAction.scale(to: 0.87, duration: 0))
        statScreen.addChild(stat_label_2)
        statBtn = getButton(frame: CGRect(x:-self.size.width/4,y:-form.frame.height/4,width:self.size.width/2,height:50), fillColor:SKColor.blue, title:"New Session", logo:nil, name:"statBtn")
        statBtn.zPosition = 1
        statScreen.addChild(statBtn)
        // Add text fields/pickers for initial state
        guard let view = self.view else { return }
        let originX = (view.frame.size.width - view.frame.size.width/1.5)/2
        pickers = []
        textFields = []
        previousSessionField = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5 - CGFloat(60), width: view.frame.size.width/1.5, height: 30))
        view.addSubview(previousSessionField)
        customize(textField: previousSessionField, placeholder: "Previous Session (Optional)")
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
        //buildStats()
    }
}
