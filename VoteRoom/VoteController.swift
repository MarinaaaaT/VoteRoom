//
//  VoteController.swift
//  VoteRoom
//
//  Created by Marina Tassi on 8/2/17.
//  Copyright © 2017 Marina Tassi. All rights reserved.
//

import UIKit
import RealmSwift

class VoteController: UIViewController {
    
    //MARK:Properties
    @IBOutlet weak var ratingController: RatingController!
    @IBOutlet weak var roomShown: UILabel!
    var roomNumber: String = "id == -1"
    let realm = try! Realm()
    var roomExists = true
    var roomNum = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomShown.text = roomNum
    
    }

    override func viewDidAppear(_ animated: Bool) {
        let room = realm.objects(VotingRoom.self).filter(roomNumber)
        if(room.count != 1){
            roomExists = false
            performSegue(withIdentifier: "backToMain", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewController {
            viewController.roomExists = roomExists
        }
        
        if let voteSubmitted = segue.destination as? VoteSubmittedController{
            voteSubmitted.roomNum = roomNum
            voteSubmitted.rating = ratingController.rating
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
