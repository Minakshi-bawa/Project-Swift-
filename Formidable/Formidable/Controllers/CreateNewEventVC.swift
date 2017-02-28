//
//  CreateNewEventVC.swift
//  Formidable
//
//  Created by Minakshi Bawa on 26/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import UIKit

class CreateNewEventVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func tapBackBtn(_ sender: UIButton)
  {
    self.navigationController!.popViewController(animated: true);
  }
  @IBAction func tapSaveBtn(_ sender: UIButton)
  {
    let alert = UIAlertController(title: "Formidable", message: "Event Created Successfully", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
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
