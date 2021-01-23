//
//  MyLocationWeather.swift
//  WeatherApp
//
//  Created by Jona Chen on 11/25/20.
//

import UIKit
import CoreLocation

class MyLocationWeather: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let hour = Calendar.current.component(.hour, from: Date())
    var locationDetails: CLLocation?
    var latitude: Double!
    var Longitude: Double!
    @IBOutlet weak var tomorrowTemp: UILabel!
    @IBOutlet weak var tomorrowTemp1: UILabel!
    @IBOutlet weak var tomorrowTemp2: UILabel!
    @IBOutlet weak var tomorrowTemp3: UILabel!
    @IBOutlet weak var tomorrowTemp4: UILabel!
    @IBOutlet weak var tomorrowTemp5: UILabel!
    @IBOutlet weak var tomorrowTemp6: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayOfWeek1: UILabel!
    @IBOutlet weak var dayOfWeek2: UILabel!
    @IBOutlet weak var dayOfWeek3: UILabel!
    @IBOutlet weak var dayOfWeek4: UILabel!
    @IBOutlet weak var dayOfWeek5: UILabel!
    @IBOutlet weak var dayOfWeek6: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var timeNow: UILabel!
    @IBOutlet weak var timeNow1: UILabel!
    @IBOutlet weak var timeNow2: UILabel!
    @IBOutlet weak var timeNow3: UILabel!
    @IBOutlet weak var timeNow4: UILabel!
    @IBOutlet weak var timeNow5: UILabel!
    @IBOutlet weak var tempNow: UILabel!
    @IBOutlet weak var tempNow1: UILabel!
    @IBOutlet weak var tempNow2: UILabel!
    @IBOutlet weak var tempNow3: UILabel!
    @IBOutlet weak var tempNow4: UILabel!
    @IBOutlet weak var tempNow5: UILabel!
    @IBOutlet weak var hourMainNow: UILabel!
    @IBOutlet weak var hourMainNow1: UILabel!
    @IBOutlet weak var hourMainNow2: UILabel!
    @IBOutlet weak var hourMainNow3: UILabel!
    @IBOutlet weak var hourMainNow4: UILabel!
    @IBOutlet weak var hourMainNow5: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named:"gradient4.jpg"))
        getLocation()
        getHourNumber(hour: hour)
        
        //print(getDayOfWeek(unixDecoder(unixCode: 1595243443))!)
        //print("This is the longitude:")
        //print(Longitude!)
        //print("And this is the latitude:")
        //print(latitude!)
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
        return 4
    }
    
    func unixDecoder(unixCode: Int) -> String {
        let temp = NSDate(timeIntervalSince1970: TimeInterval(unixCode))
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = dateFormatter.string(from: temp as Date)
        
        return stringDate
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    

    
    
    
      func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
        locationManager.requestWhenInUseAuthorization()
        return
        }
      
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
            }
    
    func showLocationServicesDeniedAlert() {
      let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let newLocation = locations.last!
      print("didUpdateLocations \(newLocation)")
        
      locationDetails = newLocation
        if let locationDetails = locationDetails {
            Longitude = locationDetails.coordinate.longitude
            latitude = locationDetails.coordinate.latitude
            
            
            //print(Longitude!)
            //print(latitude!)
            Apicall(matching: String(Longitude), matching: String(latitude))
            Apicallname(matching: String(Longitude), matching:String(latitude))
            
        }
    }
    
    @IBAction func FaveClicked(sender:UIButton){
        let cityDetails = FavoriteCitiesItem()
        cityDetails.name = location.text!
        cityDetails.lat = latitude
        cityDetails.long = Longitude
        
        sender.isUserInteractionEnabled = true
        sender.isEnabled = true
        
        let pulse1 = CASpringAnimation(keyPath:"transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1
        animationGroup.animations = [pulse1]
        sender.layer.add(animationGroup, forKey: "pulse")
        
        var favCites = PersistencyHelper.loadFavCities()
        for items in favCites {
            if(items.name == location.text!){
                let alert = UIAlertController(title: "Alert", message: "Already on Favorites List", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return;
            }
    }
        favCites.append(cityDetails)
        PersistencyHelper.saveFavCities(favCites)
        
    }
    
//    struct Main: Decodable {
//        let main:subMain
//        let name: String
//        let weather: [subWeather]
//    }
//
//    struct subMain: Decodable {
//        let temp: Float
//        let feels_like: Float
//        let temp_min: Float
//        let temp_max: Float
//        let pressure: Int
//        let humidity: Int
//    }
//
//    struct subWeather: Decodable {
//        let description: String
//    }
//
//    struct Coordinates: Decodable{
//        var longitudes:Double
//        var latitudes: Double
//    }
    
    struct nameRoot: Decodable{
        let name: String
    }
    
    
    struct Root: Decodable{
        //let alerts: [subAlert]
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
        let feels_like: Double
        let pressure: Double
        let humidity: Double
        let visibility: Double
        let wind_speed: Double
        let uvi: Double
    }
    
    //struct subAlert: Decodable {
       // let sender_name : String
    //}
 
    struct subWeather: Decodable {
        let main: String
    }
//
//    struct subDaily: Decodable {
//
//    }
//
//    struct subHourly: Decodable {
//        let dt: Int
//        let temp: Float
//
//    }
    
    
    let session = URLSession.shared
    //let url = URL(string //"https://api.openweathermap.org/data/2.5/weather?q,uk&appid=d389be338b68ef49fa52f13270960945")!
    
    
    func Apicall(matching long: String, matching lat: String) {
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
//                    let parsedJsonMain = try jsonDecoder.decode(Main.self, from: data)
//                    print(parsedJson.main.feels_like)
                        
                    DispatchQueue.main.async {
                        temperature.text = String(CtoF(temperature:Int(parsedJson.current.temp) - 273))
                        descriptionLabel.text = parsedJson.current.weather[0].main
                        high.text = "H:" + String(CtoF(temperature:Int(parsedJson.daily[0].temp.max - 273)))
                        low.text = "L:" + String(CtoF(temperature:Int(parsedJson.daily[0].temp.min - 273)))
                        getWeekNumber(number:getDayOfWeek(unixDecoder(unixCode: parsedJson.current.dt))!)
                        tempNow.text = String(CtoF(temperature: Int(parsedJson.hourly[0].temp)-273))
                        tempNow1.text = String(CtoF(temperature: Int(parsedJson.hourly[1].temp)-273))
                        tempNow2.text = String(CtoF(temperature: Int(parsedJson.hourly[2].temp)-273))
                        tempNow3.text = String(CtoF(temperature: Int(parsedJson.hourly[3].temp)-273))
                        tempNow4.text = String(CtoF(temperature: Int(parsedJson.hourly[4].temp)-273))
                        tempNow5.text = String(CtoF(temperature: Int(parsedJson.hourly[5].temp)-273))
//                        tempNow1.text = String(Int(parsedJson.hourly[1].temp) - 273)
//                        tempNow2.text = String(Int(parsedJson.hourly[2].temp) - 273)
//                        tempNow3.text = String(Int(parsedJson.hourly[3].temp) - 273)
//                        tempNow4.text = String(Int(parsedJson.hourly[4].temp) - 273)
//                        tempNow5.text = String(Int(parsedJson.hourly[5].temp) - 273)
                        hourMainNow.text = parsedJson.hourly[0].weather[0].main
                        hourMainNow1.text = parsedJson.hourly[1].weather[0].main
                        hourMainNow2.text = parsedJson.hourly[2].weather[0].main
                        hourMainNow3.text = parsedJson.hourly[3].weather[0].main
                        hourMainNow4.text = parsedJson.hourly[4].weather[0].main
                        hourMainNow5.text = parsedJson.hourly[5].weather[0].main
                        tomorrowTemp.text = String(CtoF(temperature: Int(parsedJson.daily[0].temp.day - 273)))
                        tomorrowTemp1.text = String(CtoF(temperature: Int(parsedJson.daily[1].temp.day - 273)))
                        tomorrowTemp2.text = String(CtoF(temperature: Int(parsedJson.daily[2].temp.day - 273)))
                        tomorrowTemp3.text = String(CtoF(temperature: Int(parsedJson.daily[3].temp.day - 273)))
                        tomorrowTemp4.text = String(CtoF(temperature: Int(parsedJson.daily[4].temp.day - 273)))
                        tomorrowTemp5.text = String(CtoF(temperature: Int(parsedJson.daily[5].temp.day - 273)))
                        tomorrowTemp6.text = String(CtoF(temperature: Int(parsedJson.daily[6].temp.day - 273)))
                        feelsLikeLabel.text = String(CtoF(temperature:Int(parsedJson.current.feels_like)-273)) + "°F"
                        pressureLabel.text = String(parsedJson.current.pressure) + " inHg"
                        humidityLabel.text = String(parsedJson.current.humidity) + " %"
                        visibilityLabel.text = String(parsedJson.current.visibility) + " mi"
                        windSpeedLabel.text = String(parsedJson.current.wind_speed) + " mph"
                        uviLabel.text = String(parsedJson.current.uvi)
                        
//                        print(tempElements[0])
//                        print(tempElements[1])
//                        print(tempElements[2])
//                        print(tempElements[3])
                        
                    }
            }
                catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    func CtoF(temperature Celcius: Int) -> Int{
        
        var tempF = Int()
        
        tempF = Int(Celcius*Int(1.8)+32)
        
        return tempF
    }
    
   
    
    func Apicallname(matching long: String, matching lat: String) {
        let api = "https://api.openweathermap.org"
        //let endpoint = "/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=d389be338b68ef49fa52f13270960945"
        let endpoint = "/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=d389be338b68ef49fa52f13270960945"
        let url = URL(string: api + endpoint)!
            
            
            let dataTask = session.dataTask(with: url, completionHandler:{ [self]
            data,response, error in
//                print(error)
//                print(response)
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJson = try jsonDecoder.decode(nameRoot.self, from: data)
//                    let parsedJsonMain = try jsonDecoder.decode(Main.self, from: data)
//                    print(parsedJson.main.feels_like)
                        
                    DispatchQueue.main.async {
                        location.text = parsedJson.name
                    }
            }
                catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    func getWeekNumber(number: Int) {
        switch number {
        case 1:
            dayOfWeek.text = "Sunday"
            dayOfWeek1.text = "Monday"
            dayOfWeek2.text = "Tuesday"
            dayOfWeek3.text = "Wednesday"
            dayOfWeek4.text = "Thursday"
            dayOfWeek5.text = "Friday"
            dayOfWeek6.text = "Saturday"
            
        case 2:
            dayOfWeek.text = "Monday"
            dayOfWeek1.text = "Tuesday"
            dayOfWeek2.text = "Wednesday"
            dayOfWeek3.text = "Thursday"
            dayOfWeek4.text = "Friday"
            dayOfWeek5.text = "Saturday"
            dayOfWeek6.text = "Sunday"
        
        case 3:
            dayOfWeek.text = "Tuesday"
            dayOfWeek1.text = "Wednesday"
            dayOfWeek2.text = "Thursday"
            dayOfWeek3.text = "Friday"
            dayOfWeek4.text = "Saturday"
            dayOfWeek5.text = "Sunday"
            dayOfWeek6.text = "Monday"
            
        case 4:
            dayOfWeek.text = "Wednesday"
            dayOfWeek1.text = "Thursday"
            dayOfWeek2.text = "Friday"
            dayOfWeek3.text = "Saturday"
            dayOfWeek4.text = "Sunday"
            dayOfWeek5.text = "Monday"
            dayOfWeek6.text = "Tuesday"
            
        case 5:
            dayOfWeek.text = "Thursday"
            dayOfWeek1.text = "Friday"
            dayOfWeek2.text = "Saturday"
            dayOfWeek3.text = "Sunday"
            dayOfWeek4.text = "Monday"
            dayOfWeek5.text = "Tuesday"
            dayOfWeek6.text = "Wednesday"
            
        case 6:
            dayOfWeek.text = "Friday"
            dayOfWeek1.text = "Saturday"
            dayOfWeek2.text = "Sunday"
            dayOfWeek3.text = "Monday"
            dayOfWeek4.text = "Tuesday"
            dayOfWeek5.text = "Wednesday"
            dayOfWeek6.text = "Thursday"
            
        case 7:
            dayOfWeek.text = "Saturday"
            dayOfWeek1.text = "Sunday"
            dayOfWeek2.text = "Monday"
            dayOfWeek3.text = "Tuesday"
            dayOfWeek4.text = "Wednesday"
            dayOfWeek5.text = "Thursday"
            dayOfWeek6.text = "Friday"
            
    
        default:
            dayOfWeek.text = "N/A"
            dayOfWeek1.text = "N/A"
            dayOfWeek2.text = "N/A"
            dayOfWeek3.text = "N/A"
            dayOfWeek4.text = "N/A"
            dayOfWeek5.text = "N/A"
            dayOfWeek6.text = "N/A"
            
        }
    }
    
    func getHourNumber(hour: Int) {
        if(hour > 12){
            let tempTime = hour - 12
            timeNow.text = String(tempTime) + "PM"
            
            if((tempTime + 1) > 12){
            timeNow1.text = String(tempTime+1-12) + "AM"
            }
            else {
            timeNow1.text = String(tempTime+1) + "PM"
            }
            if((tempTime + 2) > 12){
            timeNow2.text = String(tempTime+2-12) + "AM"
            }
            else {
            timeNow2.text = String(tempTime+2) + "PM"
            }
            if((tempTime + 3) > 12){
            timeNow3.text = String(tempTime+3 - 12) + "AM"
            }
            else {
            timeNow3.text = String(tempTime+3) + "PM"
            }
            
            if((tempTime + 4 ) > 12){
            timeNow4.text = String(tempTime+4-12) + "AM"
            }
            else{
            timeNow4.text = String(tempTime+4) + "PM"
            }
            
            if((tempTime + 5) > 12){
            timeNow5.text = String(tempTime+5-12) + "AM"
            }
            else{
            timeNow5.text = String(tempTime+5) + "PM"
            }
            
            
        }
        else
        {
            let tempTime = hour
            timeNow.text = String(tempTime) + "AM"
            
            if((tempTime + 1) > 12){
            timeNow1.text = String(tempTime+1-12) + "PM"
            }
            else {
            timeNow1.text = String(tempTime+1) + "AM"
            }
            if((tempTime + 2) > 12){
            timeNow2.text = String(tempTime+2-12) + "PM"
            }
            else {
            timeNow2.text = String(tempTime+2) + "AM"
            }
            if((tempTime + 3) > 12){
            timeNow3.text = String(tempTime+3 - 12) + "PM"
            }
            else {
            timeNow3.text = String(tempTime+3) + "AM"
            }
            
            if((tempTime + 4 ) > 12){
            timeNow4.text = String(tempTime+4-12) + "PM"
            }
            else{
            timeNow4.text = String(tempTime+4) + "AM"
            }
            
            if((tempTime + 5) > 12){
            timeNow5.text = String(tempTime+5-12) + "PM"
            }
            else{
            timeNow5.text = String(tempTime+5) + "AM"
            }
            
        }
    }
    
//    func updateLabels(sender: Any) {
//        temperature.text = String(Int(sender.current.temp) - 273)
//        descriptionLabel.text = sender.current.weather[0].main
//    }

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
