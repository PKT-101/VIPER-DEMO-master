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
 
        if(cell.contentView.subviews.count == 1) {
            cell.contentView.subviews[0].removeFromSuperview()
        }
        let view = UIHostingController(rootView: MovieTableViewCell(movie_: movies![indexPath.row])).view
        view?.frame = cell.contentView.frame
        cell.contentView.addSubview(view!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(Huston.shared.userStatus != .loggedIn) {
            return nil
        }
        let movie = movies![indexPath.row]
        let item = UIContextualAction(style: movie.isFavourite ? .destructive : .normal, title: movie.isFavourite ? "Delete" : "Add") {  (contextualAction, view, boolValue) in
            //Write your code in here
            boolValue(true)
            self.view.isUserInteractionEnabled = false
            Flow.shared.renderStatusView(message: "Updating favourites list")
            DataManager.switchFavouriteState(id: movie.id_pk, isFavoirte: !movie.isFavourite) { [self] in
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    Flow.shared.renderStatusView(message: "Found " + String(self.movies!.count) + " movies")
                    self.movies = try! Realm().objects(Movie.self)
                }
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}


struct MovieTableViewCell : View {
    
    @ObservedRealmObject var movie: Movie
    
    init(movie_: Movie) {
        movie = movie_
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(movie.title)
                    .padding(.leading)
                Spacer()
            }
            Spacer()
            HStack {
                Text(movie.originalTitle)
                    .padding(.leading)
                    .foregroundColor(.blue)
                Spacer()
                Image("a").frame(minWidth: 10, minHeight: 10).background(movie.isFavourite ? .yellow : .black).cornerRadius(5).padding(.trailing)
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

/*#Preview {
    MovieTableViewCell(movie: try! Realm().objects(Movie.self).first)
}*/
