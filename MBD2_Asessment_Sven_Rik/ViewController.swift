//
//  ViewController.swift
//  MBD2_Asessment_Sven_Rik
//
//  Created by Uitleen on 07/04/16.
//  Copyright © 2016 Sven Brettschneider & Rik van den Heuvel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    let pokemonSegueIdentifier = "ShowPokemonSegue"
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pokedex"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        gottaCatchEmAll()
    }
    
    //New
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == pokemonSegueIdentifier {
            if let destination = segue.destinationViewController as? PokemonViewController {
                if let pokemonIndex = self.tableView.indexPathForSelectedRow {
                    let pokemonToShow = pokemons[pokemonIndex.row]
                    destination.name = pokemonToShow.name
                    destination.id = String(pokemonToShow.id)
                    destination.height = String(pokemonToShow.height)
                    destination.weight = String(pokemonToShow.weight)
                    destination.experience = String(pokemonToShow.base_exp)
                    destination.sprite = pokemonToShow.sprite;
                }
                //print(destination)
            }
        }
    }
    
    // UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    // Maakt een cell aan
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        cell.textLabel?.text = pokemons[indexPath.row].name
        
        if(pokemons[indexPath.row].sprite != ""){
            let sprite = UIImage(data: NSData(contentsOfURL: NSURL(string:self.pokemons[indexPath.row].sprite!)!)!)
            cell.imageView?.image = sprite
        }
        
        return cell
    }
    
    // Zebra effect
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // Wanneer een pokemon geselecteerd word
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(pokemons[row].name)
    }
    
    // Fetches a list of pokemons from tha interwebz
    func gottaCatchEmAll(){
        let requestURL: NSURL = NSURL(string: "http://pokeapi.co/api/v2/pokemon?limit=5")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            // Als het request geslaagd is
            if (statusCode == 200) {
                print("The pokemon have happily gathered around you, you are now the Pokemon Master!")
                
                do{
                    // probeer de JSON op te halen
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    // Kijk of er wel pokemons in de response zitten
                    if let pokemonResults = json["results"] as? [[String: AnyObject]] {
                        
                        // Voeg voor elke pokemon in de rspons een Pokemon object toe met de naam
                        for pokemonResult in pokemonResults {
                            let name = pokemonResult["name"] as! String
                            let pokemonInstance = Pokemon(name: name)
                            
                            self.pokemons.append(pokemonInstance)
                            self.IChooseYou(pokemonInstance)
                        }
                        // Het asynchrone ophaalwerk zit er op, dus nu moeten we de data opnieuw binden
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                    
                }catch {
                    print("There seems to be a problem... all pokemon fled: \(error)")
                }
                
            }
        }
        // Start de task
        task.resume()
    }
    
    
    func IChooseYou(pokemon:Pokemon){
        let requestURL: NSURL = NSURL(string: "http://pokeapi.co/api/v2/pokemon/\(pokemon.name)")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            // Als het request geslaagd is
            if (statusCode == 200) {

                do{
                    // probeer de JSON op te halen
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    // Kijk of er wel een pokemon in de response zit en maak er een dictionary van
                    if let pokemonResults = json as? NSDictionary {
                        
                        // Vul de gegevens van een pokemon aan voor de detailview
                        pokemon.updatePokemon(pokemonResults);
                        
                        // Het asynchrone ophaalwerk zit er op, dus nu moeten we de data opnieuw binden
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                    
                }catch {
                    print("There seems to be a problem... the pokemon fainted: \(error)")
                }
            }
        }
        // Start de task
        task.resume()
    }
    
}
