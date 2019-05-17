/*****************************************************
 * An app to draw polylines in a touchscreen and 
 * export them as a JSON file
 * 
 * A project for Kids at Autodesk Day, Nov 7th 2017
 * 
 * by Nono Martinez Alonso (nono.ma)
 * and Jose Luis Garcia del Castillo (garciadelcastillo.es)
 * 
 * Open-sourced under the MIT License
 *****************************************************/

// A list of polylines to store the lines we draw
import hypermedia.net.*;
UDP udps; 
ArrayList<Polyline> polylines;

// A list of UI buttons
ArrayList<Button> buttons;
Button exportButton;
Button newButton;
Button undoButton;
float buttonWidth = 200;
float buttonHeight = 90;

// A JSON array to serialize our drawing to JSON
JSONObject json;

// Distance between points
float pointDistance = 1;

boolean shouldSaveFrame = true;

boolean isDrawingLocked = false;

void setup() {
  udps = new UDP( this, 6000 );
  // Processing setup
  //size(800,600);
  fullScreen(); 
  pixelDensity(displayDensity());
  // Add UI buttons
  buttons = new ArrayList<Button>();
  
  exportButton = new Button("Go!", new Frame(40, 50, buttonWidth, buttonHeight), "EXPORT");
  newButton = new Button("New", new Frame(260, 50, buttonWidth, buttonHeight), "NEW");
  undoButton = new Button("Undo", new Frame(480, 50, buttonWidth, buttonHeight), "UNDO");
  
  buttons.add(exportButton);
  buttons.add(newButton);
  buttons.add(undoButton);
  
  // Force load fonts?
  for(Button b : buttons) { b.render(); }
  background(255);
  
  // Init drawing
  cleanup();
}

void draw() {
  background(255);
  for(Polyline p : polylines) { p.render(); }
  if(!shouldSaveFrame) {
    // Render controls (only when we are not exporting the frame)
    for(Button b : buttons) { b.render(); }
  } else {
    // Save a snapshot of the current drawing
    String date = str(year()).substring(2)+""+nf(month(),2)+""+nf(day(),2)+"_"+nf(hour(),2)+""+nf(minute(),2)+""+nf(second(),2);
    saveFrame("data/"+date+"_drawing.jpg");
    shouldSaveFrame = false;
  }
}

//void updateUI() {
//  if(polylines.size() == 0) {
//    exportButton.isEnabled = true;
//    newButton.isEnabled = false;
//    undoButton.isEnabled = false;
//  } else {
//    exportButton.isEnabled = true;
//    newButton.isEnabled = true;
//    undoButton.isEnabled = true;
//  }
//}

// COMMANDS

// Empty existing polylines
void cleanup() {
  polylines = new ArrayList<Polyline>();
//  updateUI();
}

// If there are polylines, remove last one
void undo() {
  int count = polylines.size();
  if(count > 0) {
    polylines.remove(count-1);
  }
//  updateUI();
}

void export() {
  
  json = new JSONObject();
  JSONArray jsonArray = new JSONArray();
  for(Polyline p : polylines) {
    if(p.points.size() > 0) {
      JSONObject j = new JSONObject();
      j.setJSONArray("points", p.toJSONArray());
      //j.setInt("x",1);
      jsonArray.append(j);
    } else {
      println("skipped a polyline");    
    }
  }
  json.setJSONArray("polylines",jsonArray);
  
  shouldSaveFrame = true;
  String date = str(year()).substring(2)+""+nf(month(),2)+""+nf(day(),2)+"_"+nf(hour(),2)+""+nf(minute(),2)+""+nf(second(),2);
  saveJSONObject(json, "data/"+date+"_drawing.json");
  print("Saved JSON file and image!\n\r");
  
  //String linemessage= "";
  //for(Polyline p : polylines) {
  //  if(p.points.size() > 0) {
  //    for(Point f : p.points) {
  //      f = Point.string;
  //    linemessage.append(f);
  //  }
      
  //  }
  //}
  String message  = json.toString();//str( "hello" );  // the message to send
    String ip       = "127.0.0.1";  // the remote IP address
    int port        = 6100;    // the destination port
    //print( message );
    // formats the message for Pd
    //message = message;//+";\n";
    // send the message
    udps.send( message, ip, port );
    //locList = "";
    delay(1000);
    udps.send("true", ip, 7100 );
    delay(3000);
    udps.send("false", ip, 7100 );
}

boolean isDrawing = false;
Polyline activePolyline;

void mousePressed() {
  
   isButtonPressed = false;
   for(Button b : buttons) {
     if(b.isBelowMouse()) {
       isButtonPressed = true;
     }
   }
   
  if(mouseButton == LEFT && !isButtonPressed) {
    isDrawing = true;
    activePolyline = new Polyline();
    polylines.add(activePolyline);
  }
}

void mouseReleased() {
  if(mouseButton == LEFT) {  
    isDrawing = false;
  }
//  updateUI();
}

long lastEventTimestamp = 0;
Point lastPoint = null;

void mouseDragged(){
  if(!isDrawingLocked) {
  
  long millis = millis();
  if(lastEventTimestamp < millis) {
    if(isDrawing) {
      Point p = new Point(mouseX, mouseY, millis);
      if(lastPoint == null || lastPoint.distanceTo(p) > pointDistance) {
        activePolyline.addPoint(p);
        lastEventTimestamp = millis;
        lastPoint = p;
      }
    }
  }
  }
}

boolean isButtonPressed = false;

void mouseClicked() {
 if(mouseButton == RIGHT) {
       undo();
 }
 if(mouseButton == CENTER) {
   cleanup(); 
 }
 if(mouseButton == LEFT) {
   for(Button b : buttons) {
     if(b.isBelowMouse()) {
       
       b.click();
       
       if(b.action == "EXPORT") {
         export();
       } else if(b.action == "NEW") {
         cleanup();
       } else if(b.action == "UNDO") {
         undo();
       }
     }
   }
 }
}

void keyPressed() {
  if(keyCode == 83) {
    export();
  }
    if(keyCode == 85) {
    undo();
  }
   if(keyCode == 76) {
   isDrawingLocked = !isDrawingLocked;
  }   if(keyCode == 27) {
   export();
  }

}
