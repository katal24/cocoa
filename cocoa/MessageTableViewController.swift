//
//  MessageTableViewController.swift
//  cocoa
//
//  Created by Student on 19/01/18.
//  Copyright © 2018 KIS AGH. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh

class MessageTableViewController: UITableViewController {

    var msgs = [Message]()
    let dateFormate = DateFormatter()
    let urlString = "https://home.agh.edu.pl/~ernst/shoutbox.php?secret=ams2017"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.getMessages()
            
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
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
    
    deinit {
        tableView.dg_removePullToRefresh()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return msgs.count
    }
    
    func initMessages(){
        
    }

    @IBAction func addMessage(_ sender: Any) {
        let alertController = UIAlertController(title: "New message", message: "Please state your name and message", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Your name"
        } )
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Your message"
        } )
        let sendAction = UIAlertAction(title: "Send", style: .default, handler: { action in
            let name = alertController.textFields?[0].text
            let message = alertController.textFields?[1].text
            
            self.postMessage(name: name!, message: message!)
        })
        alertController.addAction(sendAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: { _ in })
    }
    
    func postMessage(name: String, message: String) {
        Alamofire.request(urlString, method: .post, parameters: ["name": name, "message": message]).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                self.getMessages()
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    
    func getMessages(){
      //  self.msgs = []
        Alamofire.request(urlString)
            .responseJSON { response in
                self.msgs = []
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
        
       
        
        let diffTime = NSDate().timeIntervalSince(msgs[indexPath.row].timestamp)/60
        
        if(diffTime <= 200) {
            cell?.msgTime.text = String(Int(diffTime)) + " minutes ago";
        } else {
            let timeString = String(describing: msgs[indexPath.row].timestamp);
            cell?.msgTime.text = timeString.substring(to: timeString.index(timeString.startIndex, offsetBy: 19))
        }
        
        cell?.msgText.text = msgs[indexPath.row].name! + " says: " + msgs[indexPath.row].message!
        
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
