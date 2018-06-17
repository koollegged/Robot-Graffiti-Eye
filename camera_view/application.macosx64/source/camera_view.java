import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class camera_view extends PApplet {



//output settings  
String cameraName = "";   
Capture videocam;

//screen settings
final int VIDEO_WIDTH  = 256;
final int VIDEO_HEIGHT =  192;
//final int VIDEO_WIDTH  = displayWidth;
//final int VIDEO_HEIGHT =  displayHeight;


public void setup () {
    frameRate(30);
    size (VIDEO_WIDTH, VIDEO_HEIGHT);
    
      String[] cameras = Capture.list();
  
      if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
      } else {
        for (int i = 0; i < cameras.length; i++) {
          String rF = "Rocketfish HD Webcam";
          String uS = "USB2.0 Camera";
          if(cameras[i].contains(rF)) cameraName = rF;
          if(cameras[i].contains(uS)) cameraName = uS;
    
        }
      }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    if (cameraName!="") {
      videocam = new Capture (this, width, height,cameraName);
    } else {
      videocam = new Capture (this, width, height);
    }
    videocam.start();
}
 
public void draw () {
  if (videocam.available ()) {
    videocam.read ();
  }  
  image(videocam, 0, 0); 
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "camera_view" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
