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
    @IBOutlet weak var questionShown: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    
    var roomNumber: String = "id == -1"
    var realm = try! Realm()
    var roomExists = true
    var roomNum = "0"
    var kP = "question"
    var notificationToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomShown.text = roomNum
        let room = realm.objects(VotingRoom.self).filter(roomNumber)
        
        if room.first != nil{
            notificationToken = room.first!.addNotificationBlock { change in
                switch change {
                case .change(let properties):
                    for property in properties {
                        if property.name == "question" {
                            self.updateUI()
                        }
                        else if property.name == "votingOn"{
                            self.updateUI()
                        }
                    }
                case .error(let error):
                    print("An error occurred: \(error)")
                case .deleted:
                    print("The object was deleted.")
                }
            }
        }
        
        
    }

    func updateUI(){
        let room = realm.objects(VotingRoom.self).filter(roomNumber)
        questionShown.text = String(room.first!.question)
        if room.first!.votingOn == true {
            voteButton.isEnabled = true
        }
        else{
            voteButton.isEnabled = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let room = realm.objects(VotingRoom.self).filter(roomNumber)
        if(room.count != 1){
            roomExists = false
            performSegue(withIdentifier: "backToMain", sender: self)
        }
        else{
            questionShown.text = String(room.first!.question)
            voteButton.isEnabled = room.first!.votingOn
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if let viewController = segue.destination as? ViewController {
            viewController.roomExists = roomExists
            viewController.realm = realm
            if notificationToken != nil {
                notificationToken.stop()
            }
        }
        
        if let voteSubmitted = segue.destination as? VoteSubmittedController{
            voteSubmitted.roomNum = roomNum
            voteSubmitted.rating = ratingController.rating
            voteSubmitted.realm = realm
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.stop()
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
