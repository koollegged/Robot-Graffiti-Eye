import processing.video.*;

//output settings  
String cameraName = "";   
Capture videocam;

void settings() {
  fullScreen();
}

void setup () {
    frameRate(30);
    //screen settings
    int VIDEO_WIDTH  = width;
    int VIDEO_HEIGHT = height;
   
    //updaate so code finds usb camera first, or the other
    
      String[] cameras = Capture.list();
      String rF = "Rocketfish HD Webcam";
      String uS = "Logitech Camera";
      String thisCamera = ""; 
       
      if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
      } else {
        for (int i = 0; i < cameras.length; i++) {
          if (thisCamera.equals("")) thisCamera = cameras[i];    
        }
      }

    if(thisCamera.contains(rF)) cameraName = rF;
    if(thisCamera.contains(uS)) cameraName = uS;
      
      println(thisCamera );
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    if (cameraName!="") {
      videocam = new Capture (this,VIDEO_WIDTH, VIDEO_HEIGHT,cameraName);
    } else {
      videocam = new Capture (this);
    }
    videocam.start();

}
 
void draw () {
  if (videocam.available ()) {
    videocam.read ();
  }  
  image(videocam, 0, 0); 
}
