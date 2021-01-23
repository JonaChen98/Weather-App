//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jona Chen on 11/3/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//
//    struct weatherDetails: Codable {
//        let temp: Double
//    }
//
//    struct weatherCategory: Codable {
//        let main: [Double:weatherDetails]
//    }
//
//
//    struct root: Decodable {
//        let main:response
//    }
//
//    struct response: Decodable {
//        let temp: Float
//        let feels_like: Float
//        let temp_min: Float
//    }
    
    
    @IBOutlet weak var imageLabel:UILabel!
//    let session = URLSession.shared
//    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=d389be338b68ef49fa52f13270960945")!
//
////    func weatherURL () -> URL {
////        let urlString  = String("api.openweathermap.org/data/2.5/weather?q=London&appid=d389be338b68ef49fa52f13270960945")
////        let url = URL(string:urlString)
////        return url!
////    }
//
//    @IBAction func Click(_ sender: Any) {
//        let dataTask = session.dataTask(with: url, completionHandler:{
//            data,response, error in
////                print(error)
////                print(response)
//            if let data = data {
//                let jsonDecoder = JSONDecoder()
//                do {
//                    let parsedJson = try jsonDecoder.decode(root.self, from: data)
//                    print(parsedJson.main.feels_like)
//            }
//                catch {
//                    print(error)
//                }
//            }
////            if let data = data {
////                if let jsonString = String(data: data, encoding: . utf8){
////                    print(jsonString)
////                }
////            }
//        })
//        dataTask.resume()
//
//    }
    
//        @IBAction func ButtonClicked () {
//
//        let dataTask = session.dataTask(with: url, completionHandler:{
//            data,response, error in
//                print(error)
//                print(response)
//        })
//        dataTask.resume()
//
//    }

    
    

}

