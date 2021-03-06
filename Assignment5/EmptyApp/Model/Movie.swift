//
//  Movie.swift
//  EmptyApp
//
//  Created by 陈昕昀 on 2/21/19.
//  Copyright © 2019 rab. All rights reserved.
//

import Foundation
enum MovieType{
    case Action
    case Adventure
    case Animation
    case Comedy
    case Crime
    case Documentary
    case Drama
    case Historical
    case Musical
    case Fiction
    case War
    case None
}

class Movie{
    var id: Int = movieId
    var name: String = ""
    var releaseYear: Int = 0
    var type: String = ""
    var quantity: Int = 0
    static var movieId:Int = 1
    
    init(){}
    init(Name:String, ReleaseYear: Int, Type:String, Quantity:Int){
        Movie.movieId += 1
        self.name = Name
        self.releaseYear = ReleaseYear
        self.type = Type
        self.quantity = Quantity
    }
    
    static func ExistedMovie(name:String) -> Movie?{
        for Movie in AppDelegate.MovieList{
            if(Movie.name==name){
                return Movie
            }
        }
        return nil
    }
}



