import processing.video.*;

//output settings  
String cameraName = "";   
Capture videocam;



void settings() {
//    fullScreen(P2D); may need to rebuild drivers to have this run in linux
fullScreen();

}

void setup () {
    frameRate(30);
    //screen settings
    int VIDEO_WIDTH  = width;
    int VIDEO_HEIGHT =  height;

    //size (256,192);
    print ("width-w :"+ width);
    
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
      //videocam = new Capture(this, 40*4, 30*4, cameraName);
      videocam = new Capture (this, VIDEO_WIDTH, VIDEO_HEIGHT,cameraName);
    } else {
//      videocam = new Capture(this,40*4,30*4);
      videocam = new Capture(this);
    }
    videocam.start();
}
 
void draw () {
  if (videocam.available ()) {
    videocam.read ();
  }  
  image(videocam, 0, 0); 
}
