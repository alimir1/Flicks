# Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.
- [X] Add a search bar.
- [X] All images fade in.
- [X] For the large poster, load the low-res image first, switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.

The following **additional** features are implemented:

- [X] Placeholder image when images load in detail controller.
- [X] Detail controller contains backdrop image and overview of movies.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/0Mxqwpc.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Figuring out how to subclass UIKit classes was the toughest part. Also I spent a lot of time figuring out how to toggle between grid and list layout. I figured the best way to implement it is to create a single UICollectionView but have two different Layouts (ie GridLayout and ListLayout). I started working on that for many hours until I realized that the easier way (though not the best practice) is just to create a tableView and collectionView and use "isHidden" properties to update layouts. I learned not to go too deep on something when the specs clearly specify what to do and how to do it :)

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
