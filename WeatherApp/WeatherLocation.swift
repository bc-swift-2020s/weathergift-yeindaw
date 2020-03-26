//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Dawin Ye on 3/9/20.
//  Copyright © 2020 Dawin Ye. All rights reserved.
//

import Foundation

class WeatherLocation: Codable{
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    func getData (){
        let coordinates = "\(latitude),\(longitude)"
        let urlString = "\(APIurls.darkSkyURL)\(APIKeys.darkSkyKey)/\(coordinates)"
        print("We are accessing the the url \(urlString)")
        //Create a URL
        guard let url = URL(string: urlString) else{
            print("Error: Couldn't create a URL from \(urlString)")
            return
        }
        
        //Create Session
        let session = URLSession.shared
        
        // Get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Errror: \(error.localizedDescription)")
            }
        //deal with data
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("\(json)")
            } catch {
                print("JSON Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
