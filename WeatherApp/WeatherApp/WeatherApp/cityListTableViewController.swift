//
//  cityListTableViewController.swift
//  WeatherApp
//
//  Created by Jona Chen on 12/1/20.
//

import UIKit

class cityListTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cities = [cityID]()
    var filteredCities = [cityID]()
    var latitude = Double()
    var longitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "city.list", withExtension: "json")!)
                cities = try JSONDecoder().decode([cityID].self, from: data)
                tableView.reloadData()
            }
        catch { print(error) }
        
        
        filteredCities = cities
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        cell.textLabel?.text = filteredCities[indexPath.row].name        // do something with items[indexPath.row].levels
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = []
        
        if searchText == ""{
            filteredCities = cities
        }
        
        else{
        for city in cities {
            if city.name.lowercased().contains(searchText.lowercased()){
                filteredCities.append(city)
            }
        }
        }
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //latitude = Double(filteredCities[indexPath.row].coord.lat)
        //longitude = Double(filteredCities[indexPath.row].coord.lon)
        
        performSegue(withIdentifier: "WeatherDetails", sender: self)
                
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WeatherDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let controller = segue.destination as! ChooseWeatherDetailsViewController
                controller.latitude = Double(filteredCities[indexPath.row].coord.lat)
                controller.longitude = Double(filteredCities[indexPath.row].coord.lon)
                controller.locationName = filteredCities[indexPath.row].name
            }
        }
    }
    
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    
    
    struct cityID: Decodable {
        let id: Int
        let name: String
        let country: String
        let coord: subCoord
    }
    
    struct subCoord: Decodable {
        let lon: Float
        let lat: Float
    }

    
//    struct subCity: Decodable {
//        let id: Int
//        let name: String
//        let country: String
//        let coord: subCoord
//    }
    
//    struct subCoord: Decodable {
//        let lat: Float
//        let long: Float
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
