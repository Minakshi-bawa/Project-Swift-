//
//  FirstViewController.swift
//  Formidable
//
//  Created by Minakshi Bawa on 25/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
  
  var arrEvent = [String]();
  
  
  
  
  @IBOutlet weak var tblEvent: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    arrEvent = ["hello","hii"];
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // IBAction Methods
  
  func tapToCreateEvent() -> Void
  {
    let storybord = UIStoryboard.init(name: "Main", bundle: nil);
  let createViewC = storybord.instantiateViewController(withIdentifier:"CreateNewEventVC" )
  self.navigationController?.pushViewController(createViewC, animated: true)
//  CreateNewEventVC
//    let alert = UIAlertController(title: "Formidable", message: "Teddu kutta h , press ok if you agree ;)", preferredStyle: UIAlertControllerStyle.alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//    self.present(alert, animated: true, completion: nil)
//    print("sdjkfghjkdhg lldf ghskjfdgh kjsfgh kjgh klsdjghdksjfg dfshg klsdgh");
  }
  
  //MARK:  UITableView Delegates -
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    
    return arrEvent.count + 1;    //count number of row from counting array hear cataGorry is An Array
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // create a new cell if needed or reuse an old one
    let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as UITableViewCell!
    let imgView = cell.contentView.viewWithTag(100) as! UIImageView;
    let lblWeekDay = cell.contentView.viewWithTag(101) as! UILabel;
    let lblEventDes = cell.contentView.viewWithTag(102) as! UILabel;
    let lblTime = cell.contentView.viewWithTag(103) as! UILabel;
    let  btnAdd = cell.contentView.viewWithTag(104) as! UIButton;
//    btnAdd.addTarget(self, action:"tapToCreateEvent:", for: UIControlEvents.touchUpInside);
    btnAdd.addTarget(self, action: #selector(FirstViewController.tapToCreateEvent), for: UIControlEvents.touchUpInside)
    if indexPath.row == arrEvent.count
     {
      lblTime.isHidden = true;
      lblWeekDay.isHidden = true;
      lblEventDes.isHidden  = true;
      imgView.isHidden = true;
      btnAdd.isHidden = false;
    }
    else
    {
      btnAdd.isHidden = true;
    }
    // set the text from the data model
    //    cell.textLabel?.text = self.animals[indexPath.row]
    
    return cell
  }
  
  // method to run when table view cell is tapped
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 44;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return UITableViewAutomaticDimension;
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // end of class
  
  
}

