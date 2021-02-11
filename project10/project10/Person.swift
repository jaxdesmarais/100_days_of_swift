//
//  Person.swift
//  project10
//
//  Created by Jax DesMarais-Leder on 2/5/21.
//

import UIKit

class Person: NSObject {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
