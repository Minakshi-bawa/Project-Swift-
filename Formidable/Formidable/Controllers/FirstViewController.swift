//
//  FirstViewController.swift
//  Formidable
//
//  Created by Minakshi Bawa on 25/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import UIKit
import CoreData



class FirstViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
  
  var arrEvent = [AnyObject]();
  var arrDaysOfWeek = [String]();
  var sectionIndex:Int = -1
  var dictDaysData = [String:Array<AnyObject>]()
  var arrTempData = [AnyObject]();
  
  @IBOutlet weak var tblEvent: UITableView!
  //MARK:  - View LifeCycle Methods -
  override func viewDidLoad()
  {
    super.viewDidLoad()
    arrDaysOfWeek = [sun,mon,tue,wed,thu,fri,sat]
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
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(true)
    fetchAndSortData()
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
  }
  
  func tapToExpand(sender:UIButton) -> Void
  {
    if sectionIndex != -1 && sectionIndex != sender.tag // collaps previous section or current one
    {
      let indexForSec = sectionIndex
      sectionIndex = -1
      tblEvent.reloadSections(NSIndexSet(index: indexForSec) as IndexSet, with: UITableViewRowAnimation.fade)
    }
    sectionIndex =  sectionIndex != sender.tag ? sender.tag : -1
    sender.setImage(#imageLiteral(resourceName: "Expand"), for: .normal)
    arrTempData = sectionIndex != -1 ? dictDaysData[arrDaysOfWeek[sectionIndex]]! : [AnyObject]()
    print(arrTempData)
    tblEvent.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: UITableViewRowAnimation.fade)
  }
  
  // MARK: - Internal Helper Methods -
  
  func getDayOfWeek()->Int {
    
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    let myComponents = myCalendar.components(.weekday, from: Date())
    let weekDay = (myComponents.weekday)! - 1
    return weekDay
  }
  
  func fetchAndSortData()
  {
    // delclaring the weeks data
    dictDaysData = [sun :[] ,mon:[],tue:[],wed:[],thu:[],fri:[],sat:[]]
    let fetchRequest : NSFetchRequest<Events> = Events.fetchRequest()
    do
    {
      let searchResults = try CoreDataHelper.getContext().fetch(fetchRequest)
      print("number of resuls:\(searchResults.count)")
      arrEvent = searchResults
      //      for result in searchResults as [Events]
      //      {
      //        print("\(result.title!) \(result.desc!) is \(result.duration) ")
      //      }
    }
    catch
    {
      print("Error:\(error)")
    }
    if arrEvent.count > 0
    {
      var index = 0
      for event in arrEvent as! [Events]
      {
        switch event.days!
        {
        case weekdays:
          dictDaysData[mon]?.append(index as AnyObject)
          dictDaysData[tue]?.append(index as AnyObject)
          dictDaysData[wed]?.append(index as AnyObject)
          dictDaysData[thu]?.append(index as AnyObject)
          dictDaysData[fri]?.append(index as AnyObject)
          break
        case weekEnds:
          dictDaysData[sat]?.append(index as AnyObject)
          dictDaysData[sun]?.append(index as AnyObject)
        case everyday:
          dictDaysData[mon]?.append(index as AnyObject)
          dictDaysData[tue]?.append(index as AnyObject)
          dictDaysData[wed]?.append(index as AnyObject)
          dictDaysData[thu]?.append(index as AnyObject)
          dictDaysData[fri]?.append(index as AnyObject)
          dictDaysData[sat]?.append(index as AnyObject)
          dictDaysData[sun]?.append(index as AnyObject)
        default:
          // means some in between days are selected
          if (event.days?.contains(sunDB))!
          {
            dictDaysData[sun]?.append(index as AnyObject)
          }
          if (event.days?.contains(monDB))!
          {
            dictDaysData[mon]?.append(index as AnyObject)
          }
          if (event.days?.contains(tueDB))!
          {
            dictDaysData[tue]?.append(index as AnyObject)
          }
          if (event.days?.contains(wedDB))!
          {
            dictDaysData[wed]?.append(index as AnyObject)
          }
          if (event.days?.contains(thuDB))!
          {
            dictDaysData[thu]?.append(index as AnyObject)
          }
          if (event.days?.contains(friDB))!
          {
            dictDaysData[fri]?.append(index as AnyObject)
          }
          if (event.days?.contains(satDB))!
          {
            dictDaysData[sat]?.append(index as AnyObject)
          }
        }
        index += 1
      }
      print(dictDaysData)
    }

  }
  //MARK:  - UITableView Delegates And DataSources -
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return section == weekDays ? 0 :  40
  }
  
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return weekDays + 1;
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tblEvent.frame.size.width, height: 40))
    if section == 7
    {
      return view;
    }
    view.backgroundColor = UIColor.groupTableViewBackground
    let lblTitle = UILabel.init(frame: CGRect(x: 10, y: 0, width: view.frame.size.width-10, height:40))
    lblTitle.text = arrDaysOfWeek[section]
    lblTitle.font = UIFont.systemFont(ofSize: 14)
    let lblSep = UILabel.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:1))
    lblSep.backgroundColor = UIColor.lightGray
    
    let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 40))
    button.tag = section
    button.setTitleColor(UIColor .black, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width - 60, bottom: 0, right: 0)
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
    if (section == weekDays)
    {
      return 1
    }
    else if sectionIndex == section
    {
      return  arrTempData.count
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
    
    if indexPath.section == weekDays
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
    print(arrTempData[indexPath.row] as! Int)
    // getting event from arrEvent with index from arrTemp
    let event:Events = arrEvent[arrTempData[indexPath.row] as! Int] as! Events;
    
    lblTitle.text = event.title // "Event Title"
    lblEventDes.text =  event.desc
    lblDuration.text = "duration " + event.duration! + "min(s)"
    lblWeekDay.text  = event.days
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
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
    return indexPath.section == weekDays ? false : true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.delete)
    {
      tblEvent.reloadData()
      let event:Events = arrEvent[arrTempData[indexPath.row] as! Int] as! Events;
        CoreDataHelper.getContext().delete(event)
        arrEvent.remove(at:arrTempData[indexPath.row] as! Int )
        arrTempData.remove(at:indexPath.row)
           fetchAndSortData()
        CoreDataHelper.saveContext()
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

