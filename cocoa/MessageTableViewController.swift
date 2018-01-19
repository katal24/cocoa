//
//  MessageTableViewController.swift
//  cocoa
//
//  Created by Student on 19/01/18.
//  Copyright © 2018 KIS AGH. All rights reserved.
//

import UIKit
import Alamofire

class MessageTableViewController: UITableViewController {

    var msgs = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMessages();
        getMessages();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return msgs.count
    }
    
    func initMessages(){
        
    }

    @IBAction func addMessage(_ sender: Any) {
        
    }
    
    
    func getMessages(){
        Alamofire.request("https://home.agh.edu.pl/~ernst/shoutbox.php?secret=ams2017")
            .responseJSON { response in
                
                if let object = response.result.value as? [String:[Any]], let messages = object["entries"] as? [[String: Any]]{
                    
                    for msg in messages {
                        self.msgs.append(Message(time: msg["timestamp"] as! String, nam: msg["name"] as! String, msg: msg["message"] as! String ))
                    }
                    
                    self.msgs.sort{$0.timestamp > $1.timestamp}
                    self.tableView.reloadData();
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell", for: indexPath) as? MessageTableViewCell
        
        let timeString = String(describing: msgs[indexPath.row].timestamp);
        cell?.msgTime.text = timeString.substring(to: timeString.index(timeString.startIndex, offsetBy: 19))
        cell?.msgText.text = msgs[indexPath.row].message
        
        return cell!
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
