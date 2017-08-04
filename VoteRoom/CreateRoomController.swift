//
//  CreateRoomController.swift
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

class CreateRoomController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //NOTE that until server is on remote server, we must change the server given below with the current IP
        let url = URL(string: "http://[2600:1000:b10e:a7da:90ad:d3c1:56b2:6512]:9080")
        
        //Authenticate user to create synchronized realm with
        let username = "VotingAppHost"
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: "password")
        
        SyncUser.logIn(with: usernameCredentials,
                       server: url!) { user, error in
                        //if user exists, open synchronized Realm with this user
                        if let user = user {
                            // can now open a synchronized Realm with this user
                            let syncServerURL = URL(string: "realm://[2600:1000:b10e:a7da:90ad:d3c1:56b2:6512]:9080/~/voteRealm")!
                            let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
                            
                            // Open the remote Realm
                            let realm = try! Realm(configuration: config)
                            // Any changes made to this Realm will be synced across all devices!
                        }
                            
                        //if user DNE, register a new user to host the synchronized realm
                        else if let error = error {
                            print("User DNE error" + error.localizedDescription)
                            
                            // register user
                            let newUsernameCredentials = SyncCredentials.usernamePassword(username: username, password: "password", register: true)
                            
                            // log in new user
                            SyncUser.logIn(with: newUsernameCredentials,
                                           server: url!) { user, error in
                                            //if the user did not previously exist, we need to make a new realm to work in
                                            if let user = user {
                                                // can now open a synchronized Realm with this user
                                                // Create the configuration
                                                let syncServerURL = URL(string: "realm://[2600:1000:b10e:a7da:90ad:d3c1:56b2:6512]:9080/~/voteRealm")!
                                                let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
                                                
                                                // Open the remote Realm
                                                let realm = try! Realm(configuration: config)
                                                // Any changes made to this Realm will be synced across all devices!
                                                
                                                realm.create(VotingRoom.self)
                                                realm.create(Rating.self)
                                            }
                                            //You shouldn't run into an error but it is necessary for method
                                            else if let error = error {
                                                // handle error
                                                print("Don't know how you got here error" + error.localizedDescription)
                                            }
                            }
                        }
        }
        
        //After authenticating the host user, we need to get into their realm
        let user = SyncUser.current!
        print(user)
        
        let all = SyncUser.all
        while let user = all.next(){
            user.logout()
        }
        
        
        
        
//        let url2 = URL(string:"realm://[2600:1000:b10e:a7da:90ad:d3c1:56b2:6512]:9080/~/voteRealm")
        let realm = try! Realm()
//
//        let myUsername = UIDevice.current.identifierForVendor!.uuidString
//        let rating = 5
//        let votingroomID = 10
//        
//        let r = Rating()
//        r.userID = myUsername
//        r.rating = rating
//        r.votingRoomID = votingroomID
//        try! realm.write {
//            realm.add(r)
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
