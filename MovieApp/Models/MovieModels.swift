//
//  MovieModels.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import Foundation

public enum DatabaseError: Error {
    case failedToFetch
}

struct MovieResult:Codable {
    let Search:[Movie]
}

struct Movie:Codable {
    var Title:String
    var Year:String
    var  imdbID:String
    var _Type:String
    var Poster:String
    
    private enum CodingKeys: String,CodingKey {
        case Title , Year , imdbID , _Type = "Type" , Poster
    }
}


struct MovieIDStruct:Codable {
    var Title:String
    var Year:String
    var imdbRating:String
    var Runtime:String
    var Actors:String
    var Plot:String
    var Awards:String
    var Poster:String
    var Genre:String
    var imdbID:String
    
//    private enum CodingKeys: String,CodingKey {
//        case Title , Year , imdbRating , Runtime , Actors,Plot,Awards,Poster,Genre
//    }
}
