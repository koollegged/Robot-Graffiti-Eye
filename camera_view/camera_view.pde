import processing.video.*;

//output settings  
String cameraName = "";   
Capture videocam;

//screen settings
final int VIDEO_WIDTH  = 256;
final int VIDEO_HEIGHT =  192;
//final int VIDEO_WIDTH  = displayWidth;
//final int VIDEO_HEIGHT =  displayHeight;


void setup () {
    frameRate(30);
    size (VIDEO_WIDTH, VIDEO_HEIGHT);
    //size(displayWidth, displayHeight);

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
      videocam = new Capture (this, width, height,cameraName);
    } else {
      videocam = new Capture (this, width, height);
    }
    videocam.start();

}
 
void draw () {
  if (videocam.available ()) {
    videocam.read ();
  }  
  image(videocam, 0, 0); 
}