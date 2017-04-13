//
//  SecondViewController.swift
//  Formidable
//
//  Created by Minakshi Bawa on 25/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

  @IBOutlet weak var tblAllEvents: UITableView!
    var arrEvent = [String]();
  // MARK: - View LifeCycle Methods -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK:  - UITableView Delegates And DataSources -
  

 
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    // create a new cell if needed or reuse an old one
    let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as UITableViewCell!
    let imgView = cell.contentView.viewWithTag(100) as! UIImageView;
    let lblWeekDay = cell.contentView.viewWithTag(101) as! UILabel;
    let lblEventDes = cell.contentView.viewWithTag(102) as! UILabel;
    let lblDuration = cell.contentView.viewWithTag(103) as! UILabel;
    let lblTitle = cell.contentView.viewWithTag(105) as! UILabel;
    lblDuration.isHidden = false;
    lblWeekDay.isHidden = false;
    lblEventDes.isHidden  = false;
    imgView.isHidden = false;
    lblTitle.isHidden = false
    
    lblTitle.text = "Event Title"
    lblEventDes.text = "This event is a simple testing event that has been created to show how actual view will look like after creating an event."
    lblDuration.text = "duration 3 hours 31 mins"
    lblWeekDay.text  = indexPath.row == 0 ?  "Mon Tue Wed" : "Everyday"
    //    imgView.image =  indexPath.row == 0 ?  #imageLiteral(resourceName: "first") :  #imageLiteral(resourceName: "Sphere")
    imgView.image =  indexPath.row == 0 ?  #imageLiteral(resourceName: "InCompleteEvent") :  #imageLiteral(resourceName: "CompledEvent")
    tableView.allowsSelection = false;
    return cell
  }
  
  // method to run when table view cell is tapped
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 66;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return UITableViewAutomaticDimension;
  }
 
//end of class

}

