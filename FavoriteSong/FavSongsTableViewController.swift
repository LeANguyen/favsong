//
//  FavSongsTableViewController.swift
//  FavoriteSong
//
//  Created by Dong Nguyen on 8/18/18.
//  Copyright © 2018 Dong Nguyen. All rights reserved.
//

import UIKit
import CoreData
class FavSongsTableViewController: UITableViewController {

    
    var songs: [NSManagedObject] = []
    
 override   func viewDidLoad() {
        super.viewDidLoad()
        fetchdata()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Fetch function: retrive Data
    func fetchdata() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Favsongs")
        do {
            songs = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not get stored data. \(error)")
        }
    }
    // Saving song function
    func save(title: String, artist: String, year: String, url: String, image: Data) {
        guard let songDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = songDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName:"Favsongs", in: managedObjectContext) else { return }
        let song = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        song.setValue(title, forKey: "title")
        song.setValue(artist, forKey: "artist")
        song.setValue(year, forKey: "year")
        song.setValue(url, forKey: "url")
        song.setValue(image, forKey: "image")
        do {
            try managedObjectContext.save()
            self.songs.append(song)
        } catch let error as NSError {
            print("Error occur. \(error)")
        }
    }
    // Edit song function
    func update(indexPath: IndexPath, title: String, artist: String, year: String, url: String, image: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let song = songs[indexPath.row]
        song.setValue(title, forKey: "title")
        song.setValue(artist, forKey: "artist")
        song.setValue(year, forKey: "year")
        song.setValue(url, forKey: "url")
        song.setValue(image, forKey: "image")
        do {
            try managedObjectContext.save()
            tableView.reloadData()
        } catch let error as NSError {
            print("Error occur. \(error)")
        }
    }
    // Erase song function
    func erase(_ song:NSManagedObject, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(song)
        songs.remove(at: indexPath.row)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    // Add data to cell
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let compcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     
     let song = songs[indexPath.row]
     
    compcell.textLabel?.text = song.value(forKey:"title") as? String
        compcell.detailTextLabel?.text = "Artist: \(song.value(forKey:"artist") as? String ?? "")\nYear: \(song.value(forKey:"year") as? String ?? "")"
     
     return compcell
     }
 

    //Goback List segue
    @IBAction func gobackList(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? AddSongsViewController {
            guard let title: String = viewController.titleField.text,
            let artist: String = viewController.artistField.text,
            let year: String = viewController.yearField.text,
            let url: String = viewController.urlField.text,
            let imagepic: UIImage = viewController.imageViewTable.image,
            let image:Data = UIImageJPEGRepresentation(imagepic, 1)
            else { return }
            if title != "" && artist != "" && year != "" && url != "" {
                if let indexPath = viewController.indexPathForSong {
                    update(indexPath: indexPath, title: title, artist: artist, year: year, url: url, image: image)
                } else {
                    save(title: title, artist: artist, year: year, url: url,image: image)
                }
            }
            tableView.reloadData()
        } else if let viewController = segue.source as? songDetailViewController {
            if viewController.erased {
                guard let indexPath : IndexPath = viewController.indexPath else {return}
                let song = songs[indexPath.row]
                erase(song, at: indexPath)
                tableView.reloadData()
            }
            
            
        }
}
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSong" {
            guard let naviViewController = segue.destination as? UINavigationController else { return }
            guard let viewController = naviViewController.topViewController as? songDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let song = songs[indexPath.row]
            viewController.song = song
            viewController.indexPath = indexPath
        }
    }
}
