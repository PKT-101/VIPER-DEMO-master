//
//  NowPlayingModuleView.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import SwiftUI
import RealmSwift

let MOVIE_CELL_IDENTIFIER = "MovieCell"

extension NowPlayingModule: NowPlayingModuleViewRenderer, UISearchBarDelegate {
    
    func renderView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.backgroundColor = UIColor.white
        self.title = "NOW Playing"
        
        
        let searchBarView = UISearchBar()
        searchBarView.frame = CGRect(x: 15, y: 96, width: self.view.frame.size.width - 30, height: 64)
        searchBarView.delegate = self
        
        let uiTableView = UITableView(frame: CGRect(x: 0, y: 96 + 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64 - 50 - 96))
        tableView = uiTableView
        tableView!.clipsToBounds = true
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: MOVIE_CELL_IDENTIFIER)
        tableView!.allowsSelection = true
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView!)
        self.view.addSubview(searchBarView)
    }
}

extension NowPlayingModule: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MOVIE_CELL_IDENTIFIER, for: indexPath)
 
        cell.contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let view = UIHostingController(rootView: MovieTableViewCell(movie: filteredMovies![indexPath.row])).view
        view!.frame = cell.contentView.frame
        view!.backgroundColor = UIColor.clear
        cell.contentView.addSubview(view!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        tableView.deselectRow(at: indexPath, animated: true)
        eventsHandler?.showMovieDetails(id: filteredMovies![indexPath.row].id_pk)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let movie = filteredMovies![indexPath.row]
        let item = UIContextualAction(style: movie.isFavourite ? .destructive : .normal, title: Huston.shared.userStatus == .loggedIn ? (movie.isFavourite ? "Delete" : "Add") : "Log in") { [self]  (contextualAction, view, boolValue) in
            boolValue(true)
            
            eventsHandler?.switchFavouriteStatus(movie: movie)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}

struct SearchBar : View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            Text("Searching for \(searchText)")
                .navigationTitle("Searchable Example")
        }.searchable(text: $searchText)
    }
}

struct MovieTableViewCell : View {
    
    @ObservedRealmObject var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
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
                Image(systemName: "heart.fill").frame(minWidth: 20, minHeight: 20).padding(.trailing).foregroundColor(movie.isFavourite ? .yellow : .clear)//.background().padding(.trailing)
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
    var movie_ = Movie()
    movie_.isFavourite = false
    movie_.title = "20"
    movie_.originalTitle = "200"
    
    return MovieTableViewCell(movie: movie_)
    //SearchBar() as! any View
}
