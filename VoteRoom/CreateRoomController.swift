//
//  CreateRoomController.swift
//  VoteRoom
//
//  Created by Marina Tassi on 8/2/17.
//  Copyright © 2017 Marina Tassi. All rights reserved.
//

import UIKit
import RealmSwift

class CreateRoomController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Authenticate user
//        let username = UIDevice.current.identifierForVendor!.uuidString
//        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: "password")
        
        // Login is asynchronous. If it succeeds, the User object will be
        // passed back through the callback block.
        
        //NOTE that until server is on remote server, we must change the server given below with the current IP
//        SyncUser.logIn(with: usernameCredentials,
//                       server: "localhost:9080") { user, error in
//                        if let user = user {
//                            // can now open a synchronized Realm with this user
//                        } else if let error = error {
//                            // handle error
//                        }
//        
//        // Create the configuration
//        let syncServerURL = URL(string: "realm://localhost:9080/~/userRealm")!
//        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: , realmURL: syncServerURL))
//        
//        // Open the remote Realm
//        let realm = try! Realm(configuration: config)
//        // Any changes made to this Realm will be synced across all devices!
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
