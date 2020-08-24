//
//  DetailViewController.swift
//  milestone_project_1
//
//  Created by Desmarais, Jax on 8/24/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var imageView = UIImageView()
    var selectedFlag: String?
    var selectedFlagNumber = 0
    var totalFlags = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
       setupImageView()
        
        if let flagToLoad = selectedFlag {
            imageView.image = UIImage(named: flagToLoad)
        }
    }
    
    func setupImageView() {
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found.")
            return
        }
        
        let imageName = selectedFlag?.split(separator: ".").first!.uppercased()
        
        let vc = UIActivityViewController(activityItems: [imageName, image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
