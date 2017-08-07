//
//  VoteSubmittedController.swift
//  VoteRoom
//
//  Created by Marina Tassi on 8/2/17.
//  Copyright © 2017 Marina Tassi. All rights reserved.
//

import UIKit
import RealmSwift

class VoteSubmittedController: UIViewController {
    @IBOutlet weak var thankYou: UILabel!
    @IBOutlet weak var alreadyVoted: UILabel!
    var resubmit = false
    var roomNum = "-1"
    var rating = -1
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //getuserID
        let userID = UIDevice.current.identifierForVendor!.uuidString
        
        
        //check if user already voted in this room exists
        let vr = "votingRoomID == " + roomNum
        let room = realm.objects(Rating.self).filter(vr)
        let uI = "userID CONTAINS '" + userID + "'"
        let user = room.filter(uI)
        
        if(user.count == 0){
            //send Rating
            let r = Rating()
            r.userID = userID
            r.votingRoomID = Int(roomNum)!
            r.rating = rating
            try! realm.write {
                realm.add(r)
            }
            
            //show thankYou
            alreadyVoted.isHidden = true
            thankYou.isHidden = false
        }
        else{
            //show alreadyVoted
            alreadyVoted.isHidden = false
            thankYou.isHidden = true
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let voteController = segue.destination as? VoteController {
            voteController.roomNum = roomNum
            voteController.roomNumber = "id == " + roomNum
            voteController.realm = realm
        }
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
