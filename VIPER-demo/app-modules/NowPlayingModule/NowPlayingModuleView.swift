//
//  NowPlayingModuleView.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import SwiftUI
import RealmSwift

let MOVIE_CELL_IDENTIFIER = "MovieCell"
extension NowPlayingModule: NowPlayingModuleViewRenderer {
    
    func renderView() {
        self.view.backgroundColor = UIColor.white
        
        let uiTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tableView = uiTableView
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: MOVIE_CELL_IDENTIFIER)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.backgroundColor = UIColor.lightGray
        self.view.addSubview(tableView!)
    }
}

extension NowPlayingModule: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies!.count// 0//arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MOVIE_CELL_IDENTIFIER, for: indexPath)
        //cell.backgroundColor = UIColor.blue
        if(cell.contentView.subviews.count == 1) {
            cell.contentView.subviews[0].removeFromSuperview()
        }
        let view = UIHostingController(rootView: MovieTableViewCell(movie: movies![indexPath.row])).view
        view?.frame = cell.contentView.frame
        cell.contentView.addSubview(view!)
        /*cell.mTitle.text = arrayList[indexPath.row].title
         cell.mDescription.text = arrayList[indexPath.row].brief
         
         // this things should be done in interactor where the business logid is done and should be send back to viewController
         AF.request(self.arrayList[indexPath.row].imagesource!).responseData { (response) in
         if response.error == nil {
         print(response.result)
         if let data = response.data {
         cell.mImageView.image = UIImage(data: data)
         }
         }
         }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct MovieTableViewCell : View {
    
    var movie: Movie?
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(movie!.title)
                    .padding(.leading)
                Spacer()
            }
            Spacer()
            HStack {
                Text(movie!.originalTitle)
                    .padding(.leading).foregroundColor(.blue).background(Color.red)
                Spacer()
            }
            Spacer()
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading)
    }
}

#Preview {
    MovieTableViewCell(movie: try! Realm().objects(Movie.self).first)
}
