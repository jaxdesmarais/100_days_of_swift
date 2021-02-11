//
//  ViewController.swift
//  project10
//
//  Created by Jax DesMarais-Leder on 2/1/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  var myCollectionView: UICollectionView?
  var people = [Person]()
  
  private let collectionView: UICollectionView = {
    let viewLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  private enum LayoutConstant {
    static let spacing: CGFloat = 5.0
    static let itemHeight: CGFloat = 140.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayouts()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(collectionView)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "PersonCell")
  }
  
  private func setupLayouts() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    // Layout constraints for `collectionView`
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }
  
  @objc func addNewPerson() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let picker = UIImagePickerController()
      picker.allowsEditing = true
      picker.delegate = self
      picker.sourceType = .camera
      present(picker, animated: true)
    }
    else {
      let picker = UIImagePickerController()
      picker.allowsEditing = true
      picker.delegate = self
      picker.sourceType = .photoLibrary
      present(picker, animated: true)
      print("Camera not available")
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image  = info[.editedImage] as? UIImage else { return }
    
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let person = Person(name: "Unknown", image: imageName)
    people.append(person)
    collectionView.reloadData()
    
    dismiss(animated: true)
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mainAc = UIAlertController(title: "Options", message: "Choose to rename or delete the person", preferredStyle: .actionSheet)
    
    let person = people[indexPath.item]
    
    let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] action in
      let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
      ac.addTextField()
      
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
        guard let newName = ac?.textFields?[0].text else { return }
        person.name = newName
        
        self?.collectionView.reloadData()
      })
      
      self?.present(ac, animated: true)
    }
    
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
      let ac = UIAlertController(title: "Confirm delete", message: "Are you sure you would like to delete?", preferredStyle: .alert)
      
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
        [weak self] _ in
        self?.people.remove(at: indexPath.item)
        self?.collectionView.reloadData()
      })
      self?.present(ac, animated: true)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    // Add all the actions to acMain
    mainAc.addAction(renameAction)
    mainAc.addAction(deleteAction)
    mainAc.addAction(cancelAction)
    present(mainAc, animated: true)
  }
}

// MARK: - UI Setup
extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)
    
    return CGSize(width: width, height: LayoutConstant.itemHeight)
  }
  
  func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
    let itemsInRow: CGFloat = 3
    
    let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
    let finalWidth = (width - totalSpacing) / itemsInRow
    
    return floor(finalWidth)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return LayoutConstant.spacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return LayoutConstant.spacing
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCell else {
      fatalError("Unable to dequeue PersonCell")
    }
    let person = people[indexPath.item]
    
    cell.name.text = person.name
    
    let path = getDocumentsDirectory().appendingPathComponent(person.image)
    
    cell.imageView.image = UIImage(contentsOfFile: path.path)
        
    return cell
  }
}
