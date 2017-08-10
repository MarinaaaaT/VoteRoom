//
//  ResultsController.swift
//  VoteRoom
//
//  Created by Marina Tassi on 8/2/17.
//  Copyright © 2017 Marina Tassi. All rights reserved.
//

import UIKit
import RealmSwift

class ResultsController: UIViewController {

    @IBOutlet weak var oneStar: UILabel!
    @IBOutlet weak var twoStar: UILabel!
    @IBOutlet weak var threeStar: UILabel!
    @IBOutlet weak var fourStar: UILabel!
    @IBOutlet weak var fiveStar: UILabel!
    var roomNum: String?
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for testing roomNum! is replaced with "9998"
        var s = "votingRoomID == " + roomNum!
        let room = realm.objects(Rating.self).filter(s)
        
        s = "rating == 1"
        let oneRating = room.filter(s)
        let oneCount = oneRating.count
        oneStar.text = String(oneCount)
        
        s = "rating == 2"
        let twoRating = room.filter(s)
        let twoCount = twoRating.count
        twoStar.text = String(twoCount)
        
        s = "rating == 3"
        let threeRating = room.filter(s)
        let threeCount = threeRating.count
        threeStar.text = String(threeCount)
        
        s = "rating == 4"
        let fourRating = room.filter(s)
        let fourCount = fourRating.count
        fourStar.text = String(fourCount)
        
        s = "rating == 5"
        let fiveRating = room.filter(s)
        let fiveCount = fiveRating.count
        fiveStar.text = String(fiveCount)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let hostController = segue.destination as? HostController {
            let s = "id == " + roomNum!
            let r = "votingRoomID == " + roomNum!
            let room = realm.objects(VotingRoom.self).filter(s)
            let ratings = realm.objects(Rating.self).filter(r)
            try! realm.write {
                realm.delete(room)
                realm.delete(ratings)
            }
            hostController.roomN = UInt32(roomNum!)!
            hostController.realm = realm
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
