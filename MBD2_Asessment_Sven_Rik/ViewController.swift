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
    let settingSegueIdentifier = "ShowSettingsSegue"
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pokedex"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        gottaCatchEmAll(0) // start de reis om pokemonmeester te worden! (je begint natuurlijk wel met 0 pokemon :P)
    }
    
    // Speel pokemon-data door naar de detailview van een pokemon
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
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    // Maakt een cell aan voor een pokemon (recycled zelfde cel opnieuw en opnieuw...)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        cell.textLabel?.text = pokemons[indexPath.row].name
        
        // Als er een sprite beschikbaar is, toon die dan ook maar, maakt het gehaal wat vrolijker :-)
        if(pokemons[indexPath.row].sprite != ""){
            let sprite = UIImage(data: NSData(contentsOfURL: NSURL(string:self.pokemons[indexPath.row].sprite!)!)!)
            cell.imageView?.image = sprite
        }
        
        return cell
    }
    
    // Zebra effect, omdat het kan!
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
    
    // Wanneer een pokemon geselecteerd
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(pokemons[row].name)
    }
    
    // Vangt alle pokemon, om ze zo te kunnen onderzoeken!
    func gottaCatchEmAll(offSet:Int){
        let max = 30;
        let step = 5;
        let offset = 0 + offSet;
        
        // Voer dit alleen uit als er nog geen X aantal pokemon "gevangen" zijn
        if (offset <= max){
            let requestURL: NSURL = NSURL(string: "http://pokeapi.co/api/v2/pokemon?limit=\(step)&offset=\(offset)")!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
            
                if let httpResponse = response as! NSHTTPURLResponse!{
                    let statusCode = httpResponse.statusCode
            
                    // Als het request geslaagd is
                    if (statusCode == 200) {
                        print("The pokemon have happily gathered around you, you are now the Pokemon Master!")
                
                        do{
                            // probeer de JSON op te halen
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                            // Kijk of er wel pokemons in de response zitten
                            if let pokemonResults = json["results"] as? [[String: AnyObject]] {
                        
                                // Voeg voor elke pokemon in de rspons een Pokemon object toe met zijn naam
                                for pokemonResult in pokemonResults {
                                    let name = pokemonResult["name"] as! String
                                    let pokemonInstance = Pokemon(name: name)
                                    
                                    // Knal m in z'n pokeball!
                                    self.pokemons.append(pokemonInstance)
                                    self.IChooseYou(pokemonInstance) // Onderzoek hem, verzamel zijn data! muwhahaha
                                }
                                // Het asynchrone ophaalwerk zit er op, dus nu moeten we de data opnieuw binden
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tableView.reloadData()
                                    // Oh ja, we hebben nog niet alle pokemon, dus we vangen er nog een paar >:-D
                                    self.gottaCatchEmAll(offSet + step)
                                }
                            }
                        }catch {
                            print("There seems to be a problem... all pokemon fled: \(error)")
                        }
                    }
                }
            }
            // Start de task
            task.resume()
        }
        else{
            print("Max reached, offest = \(offset)")
        }
    }
    
    // Onderzoekt een pokemon zodat we de gegevens van die pokemon kunnen updaten in onze pokedex!
    func IChooseYou(pokemon:Pokemon){
        let requestURL: NSURL = NSURL(string: "http://pokeapi.co/api/v2/pokemon/\(pokemon.name)")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as! NSHTTPURLResponse! {
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
                            print("\(pokemon.name) - \(pokemon.id)")
                        }
                    
                    }catch {
                        print("There seems to be a problem... the pokemon fainted: \(error)")
                    }
                }
                else{
                    print("could not load data for pokemon: \(pokemon.name)");
                }
            }
        }
        // Start de task
        task.resume()
    }
    
    // Om naar de settings pagina te gaan
    @IBAction func settingsTapped(sender : AnyObject) {
        self.performSegueWithIdentifier(settingSegueIdentifier, sender: self)
    }
    
}
