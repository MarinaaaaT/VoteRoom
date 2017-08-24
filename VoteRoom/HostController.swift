//
//  HostController.swift
//  VoteRoom
//
//  Created by Marina Tassi on 8/2/17.
//  Copyright © 2017 Marina Tassi. All rights reserved.
//

import UIKit
import RealmSwift

class HostController: UIViewController {
    
    //MARK:Properties
    @IBOutlet weak var roomNumber: UILabel!
    var realm = try! Realm()
    var roomN:UInt32 = arc4random_uniform(9999)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Create test room, comment out when not testing
        
//        
//        try! realm.write {
//            realm.deleteAll()
//        }

//        let vt = VotingRoom()
//        vt.id = 9998
//        try! realm.write {
//            realm.add(vt)
//        }

        //check for that room number, while exists generate new random number
        //NOTE: THIS COULD CAUSE A PROBLEM IF ROOMS EXCEED LIMIT OF 9999 (unlikely) 
        //Note: If people close the app without closing the room, rooms will not be deleted
        var randomNum:UInt32 = roomN
        roomNumber.text! = String(roomN)
        var s = "id == " + roomNumber.text!
        var room = realm.objects(VotingRoom.self).filter(s)
        
        while(room.count != 0){
            randomNum = arc4random_uniform(9999)
            roomNumber.text = randomNum.description
            s = "id == " + randomNum.description
            room = realm.objects(VotingRoom.self).filter(s)
        }
        
        //when roomnumber is chosen, create room
        let vr = VotingRoom()
        vr.id = Int(randomNum)
        vr.question = 1
        try! realm.write {
            realm.add(vr)
        }
        
    }

    @IBAction func closeRoom(_ sender: UIButton) {
        let s = "id == " + roomNumber.text!
        let room = realm.objects(VotingRoom.self).filter(s)
        try! realm.write {
            realm.delete(room)
            let s2 = "votingRoomID == " + roomNumber.text!
            let ratings = realm.objects(Rating.self).filter(s2)
            realm.delete(ratings)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultsController = segue.destination as? ResultsController {
            resultsController.roomNum = roomNumber.text
            resultsController.realm = realm
            let s = "id == " + roomNumber.text!
            try! realm.write {
                let room = realm.objects(VotingRoom.self).filter(s)
                room.first!.votingOn = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
