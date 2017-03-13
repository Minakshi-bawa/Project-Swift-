//
//  Shared.swift
//  Formidable
//
//  Created by Minakshi Bawa on 02/03/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import UIKit


class Shared: NSObject {

  static let sharedInstance: Shared = {
    let instance = Shared()
    //code setup
    return instance
  }()
  
  public func errorMsg(viewC:UIViewController, errorMsg : String) -> Void
  {
    let view = UINib(nibName: "ErrorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ErrorView
    view.lblError.text = errorMsg
//    view.alpha = 0;
    viewC.view.addSubview(view)
    UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .transitionCurlDown, animations:
      {
        view.alpha = 1
    })
    { _ in
     // after completion do nothing
    }

    UIView.animate(withDuration: 1, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
    {
      view.alpha = 0
    })
    { _ in
      view.removeFromSuperview()
    }

  }
}
