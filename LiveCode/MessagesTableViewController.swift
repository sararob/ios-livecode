//
//  MessagesTableViewController.swift
//  LiveCode
//
//  Created by Sara Robinson on 7/28/15.
//  Copyright (c) 2015 Sara Robinson. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    var messages = [[String: String]]()
    let ref = Firebase(url: "https://swift-boston.firebaseio.com/messages")

    @IBAction func addMessage(sender: UIBarButtonItem) {
        var messageAlertController = UIAlertController(title: "Add a message", message: "What would you like to say?", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Submit", style: .Default) { (action: UIAlertAction!) -> Void in

            let nameField = messageAlertController.textFields![0] as! UITextField
            let messageField = messageAlertController.textFields![1] as! UITextField
            
            let newMsg = ["name": nameField.text as String, "text": messageField.text as String]
            let newMsgRef = self.ref.childByAutoId()
            newMsgRef.setValue(newMsg) // setValue takes a bool, number, string, array, or dictionary
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        messageAlertController.addTextFieldWithConfigurationHandler { (nameText) -> Void in
            nameText.placeholder = "Your name"
        }
        
        messageAlertController.addTextFieldWithConfigurationHandler { (messageText) -> Void in
            messageText.placeholder = "Enter a message"
        }
        
        messageAlertController.addAction(addAction)
        messageAlertController.addAction(cancelAction)
        
        presentViewController(messageAlertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(animated: Bool) {
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            let msgData: AnyObject? = snapshot.value
            let newMsg = ["name": msgData?["name"] as! String, "text": msgData?["text"] as! String]
            self.messages.append(newMsg)
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messages.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! UITableViewCell
        
        let message = messages[indexPath.row]
        cell.textLabel?.text = message["text"]
        cell.detailTextLabel?.text = message["name"]

        return cell
    }

}
