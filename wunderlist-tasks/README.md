![Wunderlist Tasks widget for Übersicht](https://raw.githubusercontent.com/NikitaBazhenov/UbersichtWunderlistTasks/master/screenshot.jpg)

# Wunderlist Tasks widget for Übersicht

*Display Wunderlist open tasks on your desktop*

Prerequisites
-------------

- <img src="http://deluge-torrent.org/images/apple-logo.gif" height="17"> **Mac OS X 10.9**
- [Übersicht](http://tracesof.net/uebersicht/)

Getting Started
---------------

1. Open your widgets folder.
    > Select 'Open Widgets Folder' from the Übersicht menu in the top menu bar.
    
2. Move the widget to your widgets folder.
    > Drag the widget from your Downloads folder to the widgets folder you opened in step 1.
  
4. Configure widget   
    > Open index.coffee file
    
        #Enter your Wunderlist User Email
        email: 'email'
        
        #Enter your Wunderlist User Password
        password: 'password'
        
        #Show names of lists 
        showListsNames: true, # true / false
        
        #Show lists by names
        #Example: ['Inbox', 'Products', 'Starred']
        showLists: [] #show all by default
