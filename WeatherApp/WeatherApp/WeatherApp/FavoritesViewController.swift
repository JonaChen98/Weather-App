//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Jona Chen on 12/7/20.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
   
    var favorites = [FavoriteCitiesItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named:"wallpaper.jpg"))
        favorites = PersistencyHelper.loadFavCities()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if(editingStyle == UITableViewCell.EditingStyle.delete){
//            favorites.remove(at: indexPath.row)
//            PersistencyHelper.saveFavCities(favorites)
//            self.tableView.reloadData()
//        }
//    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            favorites.remove(at: indexPath.row)
            PersistencyHelper.saveFavCities(favorites)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCity", for: indexPath)
        let nameLabel = cell.viewWithTag(1000) as! UILabel
        //let tempLabel = cell.viewWithTag(2000) as! UILabel
        
        nameLabel.text = favorites[indexPath.row].name
//        Apicall(matching: String(favorites[indexPath.row].long), matching: String(favorites[indexPath.row].lat), Labels: tempLabel)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //latitude = Double(filteredCities[indexPath.row].coord.lat)
        //longitude = Double(filteredCities[indexPath.row].coord.lon)
        
        performSegue(withIdentifier: "FavDetails", sender: self)
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let controller = segue.destination as! FavoritesDetailsViewController
                controller.latitude = Double(favorites[indexPath.row].lat)
                controller.longitude = Double(favorites[indexPath.row].long)
                controller.locationName = favorites[indexPath.row].name
            }
        }
    }

    

    
    
    
    
    
    struct Root: Decodable{
        let alerts: [subAlert]
        let current: subCurrent
        let hourly: [subHourly]
        let daily:[subDaily]
//        let daily: [subDaily]
//        let hourly:[subHourly]
    }
    
    struct subHourly: Decodable {
        let temp: Float
        let weather: [subHourlyWeather]
    }
    
    struct subHourlyWeather: Decodable {
        let main: String
    }
    
    struct subDaily: Decodable {
        let temp: subDailyTemp
    }
    
    struct subDailyTemp: Decodable {
        let day: Float
        let min: Float
        let max: Float
    }
    
    struct subCurrent: Decodable {
        let temp: Float
        let weather: [subWeather]
        let dt: Int
    }
    
    struct subAlert: Decodable {
        let sender_name : String
    }
 
    struct subWeather: Decodable {
        let main: String
    }
    
    let session = URLSession.shared
    
    func Apicall(matching long: String, matching lat: String, Labels Label: UILabel) {
        let api = "https://api.openweathermap.org"
        //let endpoint = "/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=d389be338b68ef49fa52f13270960945"
        let endpoint = "/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid=d389be338b68ef49fa52f13270960945"
        let url = URL(string: api + endpoint)!
            
            
            let dataTask = session.dataTask(with: url, completionHandler:{ [self]
            data,response, error in
//                print(error)
//                print(response)
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJson = try jsonDecoder.decode(Root.self, from: data)

                    DispatchQueue.main.async {
                        Label.text = String(Int(parsedJson.current.temp))
                    }
            }
                catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
