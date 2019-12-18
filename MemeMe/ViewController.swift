//
//  ViewController.swift
//  MemeMe
//
//  Created by Huong Tran on 12/15/19.
//  Copyright © 2019 RiRiStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        checkShareButton()
        subcribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unSubcribeToKeyboardNotification()
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topText.text = "TEXT"
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        topText.delegate = self
        
        bottomText.text = "TEXT"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .center
        bottomText.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            checkShareButton()
            dismiss(animated: true, completion: nil)
            print("Cam")
        } else {
            print("Fail to get image")
        }
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.green,
        NSAttributedString.Key.strokeColor: UIColor.black,
        
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 4
    ]
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func pickAnImageFromAlbum (_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelEditing(_ sender: Any) {
        bottomText.text = "TEXT"
        topText.text = "TEXT"
        imageView.image = nil
        checkShareButton()
    }
    
    @IBAction func shareSNS(_ sender: Any) {
        let imageToShare = [generateMemedImage()]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print("origin y keyboardWillShow: \(view.frame.origin.y)")
        if bottomText.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide() {
        print("origin y keyboardWillHide: \(view.frame.origin.y)")
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subcribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func unSubcribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
    
    func checkShareButton() {
        if imageView.image != nil {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }

}

