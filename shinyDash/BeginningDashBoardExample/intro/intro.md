Dashboard Template
========================

This project is a shiny dashboard template to assist users in creating their own dashboard.

## Structure of the dashboard
* `app.r` 
This is the starting point of the dashboard. Used to source `global.r`, `ui.r`, and `server.r`. All are
located in the root directory.

* `global.r`
In this script you will add packages, global variables and source functions used in your app.

* `ui.r`
This script is used to source `header.r`, `sidebar.r` and `body.r`. You can also set the skin color of the
dashboard here.

     + `header.r`
      This script is used to set the dashboard header, where you can change the title, add messages, 
      notifications and task items. See shiny dashboard help for more on messages, notifications and task.

     + `sidebar.r`
     This is where you set up the menu items on the side bar. Each menu item should correspond to a folder
     of the same name. The folder will be sourced in `body.r`. Add a corresponding tab name in `body.r`.
     Leave Introduction and Acknowledgements alone,  add your menu items in between them.
     
     + `body.r`
     Sources all `ui.r` files in folders, create variable for tabItem, using tabName from `sidebar.r`, add the
     name of the .box object you created in the `ui.r` file of each folder you created. Leave start and 
     acnkowledgements alone. Add your sources in between and add the variable to the body object at 
     bottom. This is where you can use a custom css file. Place the css file in the www folder.


* `server.r`
	Sources all server.r files in folders Go to each folder you created with a shiny app and change the
	name of the .box object in ui.r to something meaningful for your application.
		
* `Introduction folder`
     Contains the r script to call `start.box` and the markdown file of your introduction page

* `Data folder` 
     Store any data the app or users need here

* `Reports folder` 
     Use this folder to store any reports the app creates

* `Functions folder`
     Store any function you will source with in the app. Source it in `global.R`  

* `Acknowledgements folder`
     Contains the r script to call `ack.box` and the markdown file for the page.
     

* `Footer.md`
     Make appropriate changes to display on footer.

* `www folder`
     If you plan to use a custom css file, place it here.  
     
## You are ready to ceate a sub app to display your analysis or visualization.  
To create a the sub app, copy the `templateSubApp` and give it a descriptive name. Remember, the `ui.R` and 
`server.R` file in this folder are a little different from a stand alone shiny app. In the subApp folder, `ui.R`
is used to create your page's UI and pass it to a `box object`. This `box object` will be added to the root 
`body.R` file to display on the main app. *(More on this below)* The `server.R` file in your subApp folder
contains your code to produce your analysis or visualization on the UI. You will source this file in the root
`server.R` file. Unlike the root `server.R` file, your subApp `server.R` code does not have to be enclosed
within a main server function.

## You Created a New Sub App: How Do I Add it to the Dashboard
In order to add your subApp to the Dashboard you will need to modify `sidebar.R`, `header.R`, `body.R`, and
`server.R` in your root directory.  

**Steps To add subapp to Dashboard**

1. Open `sidebar.r` and add the **menuItem** object. Place the item in the order you want it listed.

2. If desired, open `header.r` and add a notification of the new menu item.

3. Open `body.r`.
     + Add a source line to your `ui.` or other r file from the newly created subApp folder.
	+ Create the **tabItem** object.
	+ Add the **tabItem** object to the **dashboardBody**.
	
4. Open `server.r` and add source line to the server.r file from your newly created subApp folder.  
	
Your app should now be updated. Run `app.R` to see your added subApp.


