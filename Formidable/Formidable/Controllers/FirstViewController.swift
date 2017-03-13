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
  var arrDaysOfWeek = [String]();
  var sectionIndex:Int = -1
  
  
  
  @IBOutlet weak var tblEvent: UITableView!
  //MARK:  - View LifeCycle Methods -
  override func viewDidLoad()
  {
    super.viewDidLoad()
    arrEvent = ["hello","hii"];
    arrDaysOfWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var arrTemp = [String]()
    var weekIndex = self.getDayOfWeek()
    if  weekIndex != 0
    {
      var i:Int = 0
      while  i != 7
      {
        arrTemp.append(self.arrDaysOfWeek[weekIndex%7])  // add the weekdays from today
        i += 1
        weekIndex += 1
      }
      self.arrDaysOfWeek = arrTemp
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //MARK:  -  IBAction Methods -
  
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
  
  func tapToExpand(sender:UIButton) -> Void
  {
    if sectionIndex != -1
    {
      tblEvent.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet, with: UITableViewRowAnimation.fade)
    }
    sectionIndex = (sectionIndex == sender.tag) ? -1 : sender.tag
    sender.setImage(#imageLiteral(resourceName: "Expand"), for: .normal)
    //    tblEvent.reloadData()
    
    tblEvent.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: UITableViewRowAnimation.fade)
    //     tblEvent.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: UITableViewRowAnimation.automatic)
  }
  // MARK: - Internal Helper Methods -
  func getDayOfWeek()->Int {
    
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    let myComponents = myCalendar.components(.weekday, from: Date())
    let weekDay = (myComponents.weekday)! - 1
    return weekDay
  }
  
  //MARK:  - UITableView Delegates And DataSources -
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return section == 7 ? 0 :  40
  }
  
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 7;
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tblEvent.frame.size.width, height: 40))
    view.backgroundColor = UIColor.groupTableViewBackground
    let lblTitle = UILabel.init(frame: CGRect(x: 10, y: 0, width: view.frame.size.width-10, height:40))
    lblTitle.text = arrDaysOfWeek[section]
    lblTitle.font = UIFont.systemFont(ofSize: 14)
    let lblSep = UILabel.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:1))
    lblSep.backgroundColor = UIColor.lightGray
    
    let button = UIButton.init(frame: CGRect(x: view.frame.size.width - 60, y: 0, width: 40, height: 40))
    button.tag = section
    button.setTitleColor(UIColor .black, for: .normal)
    if sectionIndex == section
    {
      button.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
    }
    else
    {
      button.setImage(#imageLiteral(resourceName: "Expand"), for: .normal)
      
    }
    button.addTarget(self, action: #selector(FirstViewController.tapToExpand(sender:)), for: .touchUpInside)
    view.addSubview(button)
    view.addSubview(lblTitle)
    view.addSubview(lblSep)
    return view
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if (sectionIndex == -1 && section == 7)
    {
      return 1
    }
    else if sectionIndex == section
    {
      return  arrEvent.count   //count number of row from counting array hear cataGorry is An Array
    }
    return 0
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
    let  btnAdd = cell.contentView.viewWithTag(104) as! UIButton;
    btnAdd.isHidden = true
    lblDuration.isHidden = false;
    lblWeekDay.isHidden = false;
    lblEventDes.isHidden  = false;
    imgView.isHidden = false;
    lblTitle.isHidden = false
    
    if indexPath.section == 7
    {
      btnAdd.isHidden = false
      lblDuration.isHidden = true;
      lblWeekDay.isHidden = true;
      lblEventDes.isHidden  = true;
      imgView.isHidden = true;
      lblTitle.isHidden = true
      lblWeekDay.text = ""
      lblEventDes.text = ""
      lblTitle.text = ""
      
      btnAdd.addTarget(self, action: #selector(FirstViewController.tapToCreateEvent), for: UIControlEvents.touchUpInside)
      return cell
    }
    
    lblTitle.text = "Event Title"
    lblEventDes.text = "This event is a simple testing event that has been created to show how actual view will look like after creating an event."
    lblDuration.text = "duration 3 hours 31 mins"
    lblWeekDay.text  = indexPath.row == 0 ?  "Mon Tue Wed" : "Everyday"
    imgView.image =  indexPath.row == 0 ?  #imageLiteral(resourceName: "first") :  #imageLiteral(resourceName: "Sphere")
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
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
    return indexPath.section == 7 ? false : true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.delete)
    {
      tblEvent.reloadData()
      //      if (editingStyle == UITableViewCellEditingStyleDelete) {
      //        [self.toDoItem removeObjectAtIndex:indexPath.row];
      //
      //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
      //        [self.tableView reloadData];
      //
      //      }
      // handle delete (by removing the data from your array and updating the tableview)
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // end of class
  
  
}

