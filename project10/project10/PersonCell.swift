//
//  PersonCell.swift
//  project10
//
//  Created by Jax DesMarais-Leder on 2/2/21.
//

import UIKit

class PersonCell: UICollectionViewCell {
  
  private enum Constants {
      // MARK: profileImageView layout constants
      static let imageHeight: CGFloat = 100.0

      // MARK: Generic layout constants
      static let horizontalPadding: CGFloat = 5.0
      static let profileDescriptionVerticalPadding: CGFloat = 5.0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    contentView.addSubview(imageView)
    contentView.addSubview(name)
    
    setupUI()
  }
  
  // MARK: - Properties
  lazy var imageView: UIImageView = {
    let view = UIImageView(frame: .zero)
    view.layer.cornerRadius = 3
    view.layer.borderColor = UIColor.systemGray.cgColor
    view.layer.borderWidth = 1
    view.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
    return view
  }()
  
  lazy var name: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont(name: "MarkerFelt-Thin", size: 16)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.frame = CGRect(x: 10, y: 10, width: 100, height: 40)
    return label
  }()
}

// MARK: - UI Setup
extension PersonCell {
  private func setupUI() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    name.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
    ])
    
    NSLayoutConstraint.activate([
      name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
      name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
      name.topAnchor.constraint(equalTo: imageView.bottomAnchor),
      name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
