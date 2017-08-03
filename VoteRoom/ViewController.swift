//
//  ViewController.swift
//  VoteRoom
//
//  Created by Marina Tassi on 8/2/17.
//  Copyright © 2017 Marina Tassi. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: Model
final class VotingRoom: Object {
    dynamic var id = 0
    let items = List<Rating>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Rating: Object {
    dynamic var userID = ""
    dynamic var rating = 0
    dynamic var votingRoomID = 0
}

class ViewController: UIViewController {
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var confirmRoom: UIButton!
    @IBOutlet weak var roomNum: UITextField!
    let realm = try! Realm()
    var roomExists = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(!roomExists){
            errorMessage.isHidden = false
        }
        else{
            errorMessage.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let voteController = segue.destination as? VoteController {
            voteController.roomNum = roomNum.text!
            var roomNumber = "id == -1"
            if(roomNum.text != nil){
                if(Int(roomNum.text!) != nil){
                    roomNumber = "id == " + roomNum.text!
                }
            }
            voteController.roomNumber = roomNumber
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
}

