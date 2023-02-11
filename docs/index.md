#  Tab Extractor - readme

    <div>
        <div>
            <img src="img/te60x60_2x.png"
                alt="App icon"
                style="width: 200px; float: left; margin: 5px;">
        </div>
        <p>
        Guitar tabs found on the internet can be difficult for visually impaired individuals to read using screen readers. I wanted to help address this issue and make it easier for these musicians to access tabs. That's why I created 'Tab Extractor,' an app that scans pages for guitar tabs, extracts the information, and stores it in a structured format for easy reading by screen readers.
        </p>
    </div



## Why I wrote it. What it solves

Guitar tabs are notoriously inaccessible, and it can be very hard and frustrating to navigate them.
So it guitar player who relies on screen readers, will have a very hard time learning a new song using a tab.
Tab extractor makes a world of difference by transforming a very challenging task into a easy and fun one, giving the ability to swipe back-and-forth between song elements and have them read out loud.



## Technical details

The way in which TabExtractor accesses the web content is with an integrated web browser. 
This is because some websites may require signing in, or running javascript. 
So simple HTTP requests might not work. I used WKWebView wrapped in a UIViewRepresentable.



#### Detecting the presence of tabs on a page

I've decided not to hardcode any characters in the algorithm, instead, find the maximum number of lines that means certain characteristics. It must contain bars, it must have a dominant character, they have to be bars made up of this character.
Non bar characters are created as events, and if they overlap, they are grouped into clusters. Clusters Will afterwords be displayed as simultaneous events, like strumming a chord.

#### Saving and viewing

The extracted data is stored as json in the app's documents folder. It is not shared, uploaded or sent anywhere.
The tabs can then be exported and shared by the user in the following formats
* raw json-ncoded
* original text(very inaccessible)
* plain text(listed events)

## **Get the app**

[_Get on the app store_](https://apps.apple.com/app/tab-extractor/id1614273947)



[Go to repo](https://github.com/ionutsava674/Tab-Extractor)



## **App Privacy**

[privacy policy](privacypolicy.html)

[promo page](presentation.md)

--

2022

Ionut Sava
