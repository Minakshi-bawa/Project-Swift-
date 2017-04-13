//
//  CreateNewEventVC.swift
//  Formidable
//
//  Created by Minakshi Bawa on 26/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData

class CreateNewEventVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
  @IBOutlet weak var txtTitle: SkyFloatingLabelTextField!
  @IBOutlet weak var txtDescription: SkyFloatingLabelTextField!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pickerDuration: UIPickerView!
  @IBOutlet weak var switchRepeat: UISwitch!
  
  
  @IBOutlet weak var constraintPickerHT: NSLayoutConstraint!
  // declare instance variables
  
  var arrIndexces = [Int]()
  var arrPickerData = [Array<Any>]()
  var strHour = String()
  var strMin = String()
  // MARK: - View LifeCycle Methods -
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.configView()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - IBAction Methods -
  @IBAction func tapBackBtn(_ sender: UIButton)
  {
    self.navigationController!.popViewController(animated: true);
  }
  
  @IBAction func tapSaveBtn(_ sender: UIButton)
  {
    
    if self.checkForValidations()
    {
      self.view.endEditing(true)
      var dictForEvent:Dictionary<String, Any> = ["eventId":"","title":"","time":"","desc":"","duration":"","status":"","days":""]
      dictForEvent["eventId"] = self.convertCurrentDateToUTC()
      dictForEvent["status"] = switchRepeat.isOn ? "true" : "false"
      dictForEvent["desc"] = txtDescription.text!
      dictForEvent["duration"] = pickerDuration.isHidden ? "0:0" : (strHour + ":" + strMin)
      dictForEvent["title"] = txtTitle.text!
      let sum = arrIndexces[0]+arrIndexces[1]+arrIndexces[2]+arrIndexces[3]+arrIndexces[4]+arrIndexces[5]+arrIndexces[6]
      switch sum
      {
      case 127:
        dictForEvent["days"] = everyday
        print("Eveyday")
      case 31:
        print("WeekDays")
        dictForEvent["days"] = weekdays
      case 96:
        print("WeekEnds")
        dictForEvent["days"] = weekEnds
      default:
        var str = ""
        if arrIndexces[0] != 0
        {
          str = monDB
        }
        if arrIndexces[1] != 0
        {
          str = str + tueDB
        }
        if arrIndexces[2] != 0
        {
          str = str + wedDB
        }
        if arrIndexces[3] != 0
        {
          str = str + thuDB
        }
        if arrIndexces[4] != 0
        {
          str = str + friDB
        }
        if arrIndexces[5] != 0
        {
          str = str + satDB
        }
        if arrIndexces[6] != 0
        {
          str = str + sunDB
        }
        dictForEvent["days"] = str
      }
      let eventClassName :String = String(describing: Events.self) // get db class name
    
      let event:Events = NSEntityDescription.insertNewObject(forEntityName: eventClassName, into:   CoreDataHelper.persistentContainer.viewContext) as! Events
      
      event.days = dictForEvent["days"] as! String?
      event.eventId = dictForEvent["eventId"] as! String?
      event.status = ((dictForEvent["status"] as! String?) != nil)
      event.desc = dictForEvent["desc"] as! String?
      event.duration = dictForEvent["duration"] as! String?
      event.title = dictForEvent["title"] as! String?
      
      CoreDataHelper.saveContext()
          let alert = UIAlertController(title: kAppName, message: kCreateSuccessMsg, preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.default, handler: popCurrentView))
          self.present(alert, animated: true, completion: nil)
    }
  }
  func popCurrentView(action: UIAlertAction) -> Void
  {
   _ = navigationController?.popViewController(animated: true)
  }
  func convertCurrentDateToUTC() -> String
  {
    let date = Date()
    print(date)
    let df = DateFormatter()
    df.dateFormat = "ddMMyyyyhhmmss"
    let stringFromDate = df.string(from: Date())
    return stringFromDate
  }
  @IBAction func valueChangedSwitch(_ sender: UISwitch)
  {
    pickerDuration.isHidden = !sender.isOn
    constraintPickerHT.constant = sender.isOn ? 161 : 0
  }
  @IBAction func didValueChangedRep(_ sender: UISwitch)
  {
    
  }
  // MARK: - Internal Helper Methods -
  func configView() -> Void
  {
    arrIndexces = [0,0,0,0,0,0,0]
    //    pickerDuration.isHidden = true
    pickerDuration.delegate = self
    pickerDuration.dataSource = self
    let arrHours = [00,01,02,03,04,05,06,07,08,09,10,11,12]
    let arrMin = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    arrPickerData = [arrHours,arrMin]
  }
  
  func checkForValidations() -> Bool
  {
    let sum = arrIndexces[0]+arrIndexces[1]+arrIndexces[2]+arrIndexces[3]+arrIndexces[4]+arrIndexces[5]+arrIndexces[6]
    if txtTitle.text?.characters.count == 0
    {
      Shared.sharedInstance.errorMsg(viewC: self, errorMsg: "Please enter event Title")
      return false
    }
    else if sum == 0
    {
      Shared.sharedInstance.errorMsg(viewC: self, errorMsg: "Please select day(s)")
      return false
    }
    else if strMin == "0" && constraintPickerHT.constant != 0
    {
      Shared.sharedInstance.errorMsg(viewC: self, errorMsg: "Please enter valid duration")
      return false
    }
    return true
  }
  


  // MARK: - UICollectionView Delegates And DataSources -
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7;
  }
  
  // make a cell for each cell index path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath as IndexPath)
    
    // Use the outlet in our custom class to get a reference to the UILabel in the cell
    let btnWeek = cell.contentView.viewWithTag(101) as! UIButton;
    btnWeek.layer.cornerRadius = btnWeek.frame.size.height / 2;
    btnWeek.layer.borderColor = UIColor.lightGray.cgColor
    if arrIndexces[indexPath.item] != 0
    {
      btnWeek.backgroundColor = UIColor.red
    }
    else
    {
      btnWeek.backgroundColor = UIColor.init(colorLiteralRed: 77.0/255.0, green: 148.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    btnWeek.layer.borderWidth = 1.0
    btnWeek.layer.borderColor = UIColor.lightGray.cgColor
    btnWeek.layer.masksToBounds = true;
    let strTitle = indexPath.item == 0 ? "Mon" :indexPath.item == 1 ? "Tue" : indexPath.item == 2 ? "Wed" : indexPath.item == 3 ? "Thu" : indexPath.item == 4 ? "Fri" : indexPath.item == 5 ? "Sat" : "Sun"
    btnWeek.setTitle(strTitle, for: .normal)
    //    cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
  {
    // handle tap events
    let cell = collectionView.cellForItem(at: indexPath) as UICollectionViewCell!
    let btnWeek = cell?.contentView.viewWithTag(101) as! UIButton;
    if btnWeek.isSelected
    {
      btnWeek.isSelected = false
      arrIndexces[indexPath.item] =  0
      btnWeek.backgroundColor = UIColor.init(colorLiteralRed: 77.0/255.0, green: 148.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    else
    {
      arrIndexces[indexPath.item] = (indexPath.item * 2 == 0 ? 1 :   2 ^^ indexPath.row)
      btnWeek.isSelected = true
      btnWeek.layer.backgroundColor = UIColor.red.cgColor
    }
    print("You selected cell #\(indexPath.item)!")
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    var size = CGSize()
    size.height = ((UIScreen.main.bounds.width-5) / 7 ) - 7
    size.width = ((UIScreen.main.bounds.width-5) / 7 ) - 7
    return size
  }
  // MARK: - UIPickerView Delegates And DataSources -
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int
  {
    return arrPickerData.count
  }
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
  {
    if component == 0
    {
      return arrPickerData[0].count
    }
    return arrPickerData[1].count
  }
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
  {
    if component == 0
    {
      let arrHourse = arrPickerData[0]
      strHour = (arrHourse[row] as AnyObject).stringValue
      return strHour + " h  "
    }
    let arrMin = arrPickerData[1]
    strMin =  (arrMin[row] as AnyObject).stringValue
    return   strMin + "  mins"
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
  {
    if component == 0
    {
      print("Selected housr ===\(arrPickerData[0][row])")
    }
    else
    {
      print("Selected mins ===\(arrPickerData[1][row])")
    }
  }
  //MARK: - UITextField Delegates
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    return self.view.endEditing(true)
  }
  //  public func textFieldDidEndEditing(_ textField: UITextField)
  //  {
  //
  //  }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
  return Int(pow(Double(radix), Double(power)))
}
