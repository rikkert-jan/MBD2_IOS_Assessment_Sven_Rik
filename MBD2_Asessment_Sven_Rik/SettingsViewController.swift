//
//  SettingsViewController.swift
//  MBD2_Asessment_Sven_Rik
//
//  Created by Uitleen on 08/04/16.
//  Copyright © 2016 Sven Brettschneider & Rik van den Heuvel. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var experienceSwitch: UISwitch!
    @IBOutlet weak var weightSwitch: UISwitch!
    @IBOutlet weak var heightSwitch: UISwitch!
    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var idSwitch: UISwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Settings"
        
        if(defaults.boolForKey("showId")){
            idSwitch.setOn(true, animated: true)
        }else{
            idSwitch.setOn(false, animated: true)
        }
        if(defaults.boolForKey("showName")){
            nameSwitch.setOn(true, animated: true)
        }else{
            nameSwitch.setOn(false, animated: true)
        }
        if(defaults.boolForKey("showHeight")){
            heightSwitch.setOn(true, animated: true)
        }else{
            heightSwitch.setOn(false, animated: true)
        }
        if(defaults.boolForKey("showWeight")){
            weightSwitch.setOn(true, animated: true)
        }else{
            weightSwitch.setOn(false, animated: true)
        }
        if(defaults.boolForKey("showExperience")){
            experienceSwitch.setOn(true, animated: true)
        }else{
            experienceSwitch.setOn(false, animated: true)
        }
    }
    
    
    @IBAction func idSwitchChanged(sender : AnyObject) {
        if(defaults.boolForKey("showId")){
            defaults.setBool(false, forKey: "showId")
        }else{
            defaults.setBool(true, forKey: "showId")
        }
        print(defaults.boolForKey("showId"))
    }
    @IBAction func nameSwitchChanged(sender : AnyObject) {
        if(defaults.boolForKey("showName")){
            defaults.setBool(false, forKey: "showName")
        }else{
            defaults.setBool(true, forKey: "showName")
        }
        print(defaults.boolForKey("showName"))
    }
    @IBAction func heightSwitchChanged(sender : AnyObject) {
        if(defaults.boolForKey("showHeight")){
            defaults.setBool(false, forKey: "showHeight")
        }else{
            defaults.setBool(true, forKey: "showHeight")
        }
        print(defaults.boolForKey("showHeight"))
    }
    @IBAction func weightSwitchChanged(sender : AnyObject) {
        if(defaults.boolForKey("showWeight")){
            defaults.setBool(false, forKey: "showWeight")
        }else{
            defaults.setBool(true, forKey: "showWeight")
        }
        print(defaults.boolForKey("showWeight"))
    }
    @IBAction func experienceSwitchChanged(sender : AnyObject) {
        if(defaults.boolForKey("showExperience")){
            defaults.setBool(false, forKey: "showExperience")
        }else{
            defaults.setBool(true, forKey: "showExperience")
        }
        print(defaults.boolForKey("showExperience"))
    }
}
