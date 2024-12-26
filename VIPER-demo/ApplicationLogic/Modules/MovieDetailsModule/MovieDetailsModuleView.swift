//
//  MovieDetailsModuleView.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 25/12/2024.
//  Copyright © 2024 Tootle. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

let IMAGE_API_SERVER = "https://image.tmdb.org/t/p/original"

extension MovieDetailsModule: MovieDetailsModuleViewRenderer {
    
    func renderView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.bordered, target: self, action: #selector(pop(sender:)))
        newBackButton.width = 20
        newBackButton.tintColor = UIColor.systemRed
        
        self.navigationItem.leftBarButtonItem = newBackButton
            
        self.view.backgroundColor = UIColor.systemBackground
        self.title = movie!.title
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 96, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 96 - 50))
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        AF.request(URL(string: (IMAGE_API_SERVER + movie!.posterPath))!).responseImage { response in
          if case .success(let image) = response.result {
            print("image downloaded: \(image)")
              imageView.image = image
          }
        }
    }
    
    @objc func pop(sender: UIBarButtonItem) {
        eventsHandler!.pop()
    }
}
