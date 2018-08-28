//
//  songDetailViewController.swift
//  FavoriteSong
//
//  Created by Dong Nguyen on 8/19/18.
//  Copyright © 2018 Dong Nguyen. All rights reserved.
//

import UIKit
import CoreData
class songDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imageViewDetail: UIImageView!
    var song: NSManagedObject? = nil
    var erased: Bool = false
    var indexPath: IndexPath? = nil
    var url:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = song?.value(forKey:"title") as? String
       artistLabel.text = song?.value(forKey:"artist") as? String
        yearLabel.text = song?.value(forKey:"year") as? String
        url = (song?.value(forKey:"url") as? String)!
        imageViewDetail.contentMode = .scaleToFill
        if let imageData = song?.value(forKey: "image") as? Data {
            
                imageViewDetail.image = UIImage(data: imageData)
        }else{
            
                imageViewDetail.image = UIImage(named: "imageunknow")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTitle))
        titleLabel.addGestureRecognizer(tap)
        imageViewDetail.layer.cornerRadius = imageViewDetail.frame.size.width / 2
        imageViewDetail.clipsToBounds = true
    }
    @objc func didTapTitle() {
        if (url.contains("http:/")) || (url.contains("https://")) {
            let url = URL(string: "\(self.url)")
            UIApplication.shared.open(url!, options: [:])
        }else{
            let url = URL(string: "http:/\(self.url))")
            UIApplication.shared.open(url!, options: [:])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        performSegue(withIdentifier: "gobackList", sender: self)
    }
    
    @IBAction func didtapDelete(_ sender: Any) {
        erased = true
        performSegue(withIdentifier: "gobackList", sender: self)
        }
    
    @IBAction func didTapImage(_ sender: Any) {
        if (url.contains("http:/")) || (url.contains("https://")) {
            let url = URL(string: "\(self.url)")
        UIApplication.shared.open(url!, options: [:])
        }else{
            let url = URL(string: "http:/\(self.url)")
        UIApplication.shared.open(url!, options: [:])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSong" {
            guard let viewController = segue.destination as? AddSongsViewController else { return }
            viewController.titleText = "Edit Song"
            viewController.songs = song
            viewController.indexPathForSong = self.indexPath!
        }
    }
}
