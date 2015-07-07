//
//  ExampleController.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

struct Album {
    let title: String
    let releaseDate: String!
    let image: UIImage!
    let tracks: [Track]
}

struct Track {
    let title: String!
    let duration: String!
}

struct Artist {
    let name: String!
    let photo: UIImage!
    let albums: [Album]
    
}

private let dylan = Artist(name: "Bob Dylan", photo: UIImage(named: "dylan.jpeg")!, albums: [
    Album(title: "The Freewheelin' Bob Dylan", releaseDate: "1963", image: UIImage(named: "freewheel.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    Album(title: "Blonde on Blonde", releaseDate: "May 16, 1966", image: UIImage(named: "blonde.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    Album(title: "Blood on the Tracks", releaseDate: "January 17, 1975", image: UIImage(named: "blood.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    Album(title: "Love and Theft", releaseDate: "September 10, 2001", image: UIImage(named: "love.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    ])

private let killers = Artist(name: "The Killers", photo: UIImage(named: "killers.jpeg")!, albums: [
    Album(title: "Hot Fuss", releaseDate: "2004", image: UIImage(named: "hot.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    Album(title: "Sam's Town", releaseDate: "2006", image: UIImage(named: "sam.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    Album(title: "Day and Age", releaseDate: "January 17, 1975", image: UIImage(named: "day.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    Album(title: "Battle Born", releaseDate: "September 10, 2001", image: UIImage(named: "battle.jpeg"), tracks: [
        Track(title: "Blowin' in the Wind", duration: "2:42"),
        Track(title: "Girl From the North", duration: "3:23"),
        Track(title: "Masters of War", duration: "4:23"),
        Track(title: "Down the Highway", duration: "3:27"),
        Track(title: "A Hard Rain Falls", duration: "6:51"),
        ]),
    ])

class ExampleController: MasterDetailController {
    
    let artists: [Artist] = [dylan, killers]
    override func viewDidLoad() {
        dataSource = self
        super.viewDidLoad()
    }
}

extension ExampleController: MasterDetailDataSource {
    
    func masterDetailController(detailCellForRowAtIndexPath indexPath: NSIndexPath) -> DetailCell {
        let cell = self.getCell(forDetailContainer: self.detailContainer, withStyle: .Default)
        let album = self.artists[indexPath.section].albums[indexPath.row]
        cell.titleLabel?.text = album.title
        let image = album.image!
        cell.centerImageView?.image = image
        var dText = "TRACKS"
        for (i,t) in enumerate(album.tracks) {
            dText = dText + "\n \(i)- \(t.title)"
        }
        cell.descriptionLabel!.text = dText
        return cell
    }
    
    func masterDetailController(masterCellForSection section: Int) -> MasterCell {
        let cell = self.getCell(forMasterContainer: self.masterContainer, withStyle: .Default)
        let artist = artists[section]


        cell.titleLabel?.text = "  " + artist.name
        let image = artist.photo!

        cell.centerImageView!.image = image
        return cell
    }
    
    func numberOfSections() -> Int {
        return self.artists.count
    }
    
    func masterDetailController(numberOfRowsInSection section: Int) -> Int {
        return self.artists[section].albums.count
    }
}
