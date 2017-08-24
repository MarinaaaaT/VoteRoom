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
    dynamic var question = 1
    dynamic var votingOn = false
    
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
    
    //MARK: Properties
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Logout all users
        let all = SyncUser.all
        for user in all{
            user.value.logOut()
        }

        
        let url = URL(string: "http://165.227.86.55:9080")
        
        //Authenticate user to create synchronized realm with
        let username = "VRHost"
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: "password")
        login(userCred: usernameCredentials, url: url!, username: username)
    }
    
    func login(userCred: SyncCredentials, url: URL, username: String){
        SyncUser.logIn(with: userCred,
                       server: url) { user, error in
                        print("This statement will not print")
                        //if user exists, open synchronized Realm with this user
                        if let user = user {
                            print(user)
                        }
                            //if user DNE, register a new user to host the synchronized realm
                        else if let error = error {
                            print("User DNE error" + error.localizedDescription)
                            
                            // register user
                            let newUsernameCredentials = SyncCredentials.usernamePassword(username: username, password: "password", register: true)
                            
                            // log in new user
                            SyncUser.logIn(with: newUsernameCredentials,
                                           server: url) { user, error in
                                            //if the user did not previously exist, we need to make a new realm to work in
                                            if let user = user {
                                                // Can now open a synchronized Realm with this user
                                                // Any changes made to this Realm will be synced across all devices!
                                                print(user)
                                            }
                                                //You shouldn't run into an error but it is necessary for method
                                            else if let error = error {
                                                // handle error
                                                print("Don't know how you got here error" + error.localizedDescription)
                                            }
                            }
                        }
                        else{
                            print("NOT DOING ANYTHING")
                        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewController {
            let user = SyncUser.current!
            print(user)
            
            // Create the configuration
            let syncServerURL = URL(string: "realm://165.227.86.55:9080/~/voteRealm")!
            let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
            
            // Open the remote Realm
            realm = try! Realm(configuration: config)
            
            viewController.realm = realm
        }
        
        if let hostController = segue.destination as? HostController {
            let user = SyncUser.current!
            print(user)
            
            // Create the configuration
            let syncServerURL = URL(string: "realm://165.227.86.55:9080/~/voteRealm")!
            let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
            
            // Open the remote Realm
            realm = try! Realm(configuration: config)
            
            hostController.realm = realm
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
