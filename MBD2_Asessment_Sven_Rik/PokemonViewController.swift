//
//  PokemonViewController.swift
//  MBD2_Asessment_Sven_Rik
//
//  Created by Uitleen on 08/04/16.
//  Copyright © 2016 Sven Brettschneider & Rik van den Heuvel. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var pokemonExperienceLabel: UILabel!
    @IBOutlet weak var pokemonWeightLabel: UILabel!
    @IBOutlet weak var pokemonHeightLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    var id = String();
    var name = String();
    var sprite = String();
    var height = String();
    var weight = String();
    var experience = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = self.name
        pokemonIdLabel.text = self.id
        pokemonExperienceLabel.text = self.experience
        pokemonWeightLabel.text = self.weight
        pokemonHeightLabel.text = self.height
        pokemonNameLabel.text = self.name
        
        if (sprite != ""){
            let spriteImage = UIImage(data: NSData(contentsOfURL: NSURL(string:self.sprite)!)!)
            pokemonSpriteImageView.image = spriteImage;
        }
    }
    
    @IBAction func sendDataTapped(sender : AnyObject) {
        print("you tapped ze button")
        let urlString = "Data generated with pokemon app for pokemon \(self.name); \n ID: \(self.id) \n Name: \(self.name) \n Height: \(self.height) \n Weight: \(self.weight) \n Exp.: \(self.experience) \n"
        let urlStringEncoded = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
}
