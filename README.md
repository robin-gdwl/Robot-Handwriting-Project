### Created by Robin Godwyll   
Robot Lab Residency Summer 2019  
BURG Halle University of Art and Design


# Robot Handwriting
Uses Grasshopper and Processing to capture drawings via touch input and creates Robot commands to copy the drawing.

## Demo

## How to use

Install necessary Plugins (see below).   
Press ""Clone or Download" and download the Project as a .zip file.  
Unzip the file.  
Open the grasshopper definition in Grasshopper and make sure all components have loaded and no error messages are present. If you receive any errors check if all plugins are installed correctly (don't forget to unblock and follow the instructions for the "Robots"-plugin precisely)
Open touch_drawing_to_json_and_gh.pde in Processing and press Play.


## Requirements:
**Software**

- Rhino 6 (using Rhino 5 will require some rewiring, use the canvas capture as a guide)
- Grasshopper 1.0.0007
- Processing 3.5.3

**Plugins and Libraries:**

You need to install the following **Grasshopper Plugins:**

- [**Robots 0.0.5**](https://github.com/visose/Robots) (generates Robot commands from Grasshopper planes and sends the commands directly to the robot. Make sure you install it correctly.)
- [**gHowl r50**](https://www.food4rhino.com/app/ghowl) (handles the communication between Grasshopper and processing)
- [**ghJSON 1.0.0.0**](https://mathrioshka.ru/ghjson/) (required to convert the sketch lines from JSON to Grasshopper points)  

Optional:
- [MetaHopper 1.2.0](ttps://www.food4rhino.com/app/metahopper) (creates a preview sketch on the grasshopper canvas)

You also need the following **Processing libraries**:
- [**UDP**](http://ubaa.net/shared/processing/udp/)(can be installed directly in Processing by going to `Sketch>import library>Add Library`. Or by Installing from the zip-file)

## Overview

![Robot Handwriting overview]()


## Bugs to fix

- [ ] Amount of points that can be sent between Processing and GH is limited (no idea why)
