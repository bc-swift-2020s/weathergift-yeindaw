//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Dawin Ye on 3/25/20.
//  Copyright © 2020 Dawin Ye. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    var weatherLocations: [WeatherLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        loadLocations()
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    func loadLocations() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
            print("Warning: Could not load weatherLocations data from UserDefaults. Ignore this message if this is right after the app has been installed.")
            //get the user location for the first element in weatherLocations
            weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("ERROR: Couldn't decode data read from UserDefaults.")
        }
        if weatherLocations.isEmpty {
            //get the user location for the first element in weatherLocations
            weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))
        }
    }
    func createLocationDetailViewController(forPage page: Int) -> LocationDetailViewController{
        let detailViewController = storyboard!.instantiateViewController(identifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
        return detailViewController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex-1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count-1 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex+1)
            }
        }
        return nil
    }
    
    
}
