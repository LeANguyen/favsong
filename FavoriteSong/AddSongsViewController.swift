//
//  AddSongsViewController.swift
//  FavoriteSong
//
//  Created by Dong Nguyen on 8/18/18.
//  Copyright © 2018 Dong Nguyen. All rights reserved.
//

import UIKit
import CoreData

class AddSongsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var saveorupButton: UIButton!
    @IBOutlet weak var imageViewTable: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var titleText = "Add Songs"
    var songs: NSManagedObject? = nil
    var indexPathForSong: IndexPath? = nil
    var indexPath: IndexPath? = nil
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        yearField.keyboardType = .numberPad
        if let songs = self.songs {
            titleField.text = songs.value(forKey: "title") as? String
            artistField.text = songs.value(forKey: "artist") as? String
            yearField.text = songs.value(forKey: "year") as? String
            urlField.text = songs.value(forKey: "url") as? String
        }
            imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Navigation
    // Perform when user tap upload image
    @IBAction func didTapUpload(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    // Perform when user press Save button
    @IBAction func didTapSave(_ sender: Any) {
        performSegue(withIdentifier: "gobackList", sender: self)    }
    // Perform when user press Cancle button
    @IBAction func didTapCancel(_ sender: Any) {
        titleField.text = nil
        artistField.text = nil
        yearField.text = nil
        urlField.text = nil
        performSegue(withIdentifier: "gobackList", sender: self)
    }
    // Reading picked image function
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViewTable.contentMode = .scaleToFill
            imageViewTable.image = pickedImage
            let img = UIImage(named: "saved")
            uploadButton.setImage(img , for: .normal)
    }
    
    dismiss(animated: true, completion: nil)
    }
  // Return if users press cancel when choosing image
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
