import processing.video.*;
import blobDetection.*;

//increment of objects being drawn
int currCount = 0;
      
 
//when off, objects are cleared from screen
String state ="on";
String streamFrame = "off";

//sample rate
int drawNFrame = 2;

//current color of object
int currR, currG, currB;
color pixelColor;

//list to store locations of objects
ArrayList xPosArr  = new ArrayList();

//draw settings
DrawParamThread dParam;
String[] dParams;

//output settings  
String cameraName = "";   
Capture videocam;
BlobDetection theBlobDetection;
PImage blobImg;
boolean newFrame=false;

//screen settings
final int VIDEO_WIDTH  = 1024;
final int VIDEO_HEIGHT =  768;
//final int VIDEO_WIDTH  = displayWidth;
//final int VIDEO_HEIGHT =  displayHeight;


HashMap zMap = new HashMap(8);
 
// tracking Position
float xpos = 0, lxpos = 0, xdim = 0;
float ypos = 0, lypos = 0, ydim = 0;
float zpos = 0;

float step = 0.02/drawNFrame; // Size of each step along the path
float pct = 0.0; // Percentage traveled (0.0 to 1.0)

DrawnObject dObject = new DrawnObject();
int fillalpha = 102;
float strokealpha = 53;
color strokecolor = 10;
PImage whiteBg;
PImage blackBg;

void setup () {
    frameRate(30);
    //ERROR - Needs to be number values
    size (VIDEO_WIDTH, VIDEO_HEIGHT, P3D);
    //updaate so code finds usb camera first, or the other
    
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
      
      println(cameraName);
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    if (cameraName!="") {
      videocam = new Capture (this, width, height,cameraName);
    } else {
      videocam = new Capture (this, width, height);
    }
    videocam.start();
    whiteBg = loadImage("white.png");
    blackBg = loadImage("black.png");
    noFill();
    //noStroke();
    strokeWeight (2);
    stroke (255, 0, 102);
    dParam = new DrawParamThread(2000);
    dParam.start();
    zMap.put(0.25, new Float (10.0)); zMap.put(0.5, new Float(5.0)); zMap.put(0.75, new Float(3.0)); zMap.put(1.0, new Float(2.0)); zMap.put(2.0, new Float(1.0)); zMap.put(3.0, new Float(0.75));  zMap.put(5.0, new Float(0.5)); zMap.put(10.0, new Float(0.25));
    // BlobDetection
    // img which will be sent to detection (a smaller copy of the cam frame);
    blobImg = createImage(80,60,RGB); 
    
    //img = new PImage(80,60); 
    theBlobDetection = new BlobDetection(blobImg.width, blobImg.height);
    theBlobDetection.setPosDiscrimination(true);
    theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;

}
 
// ==================================================
// captureEvent()
// ==================================================
void captureEvent(Capture cam)
{
  videocam.read();
  newFrame = true;
}

// ==================================================
// draw()
// ==================================================
void draw () {
  //high quality document
  if (streamFrame.equals("on")) saveFrame("mov/graffiti-## ##.tif"); 
  //if (streamFrame.equals("on")) saveFrame("mov/graffiti-## ##.png"); 
  background (255);    
  lights();
  smooth();
  
  //LIGHTING POROPERTIES
  lightSpecular(204, 204, 204); 
  directionalLight(128,128,128, 1.5, -2, -1); 
  directionalLight(128, 128, 128, 0, 2, 0); 
  //ambientLight(255,255,255);
   
   
   //MATERIAL PROPERTIES
  //emissive(126,126,126);
  shininess(3.0);

  
  //flip image on vertical axis. Might be useful when interactive
 /* 
  pushMatrix();
  scale(-1,1);
  translate(-width, 0);
  image(videocam, 0, 0); 
  popMatrix();
 */

 image(videocam, 0, 0); 
  
  
  if (state.equals("on")) {
    PImage cm = get();
    image(cm, 0,0);  
    cm.loadPixels();      
    image(blackBg, 0, 0);
    if (streamFrame.equals("off")) image(cm, 0, 0, width/12, height/12); 
   
    int this_height=cm.height;int this_width=cm.width;
    
    
    if (frameCount % drawNFrame == 0){ 
      float brightestValue = 0, dimValue = 255; // Brightness of the brightest video pixel
      int index = 0; 
      for (float  j= 0; j < this_height; j++) {
        for (float i = 0; i < this_width; i++) {
        // Get the color stored in the pixel
        int pixelValue = cm.pixels[index];
        pixelColor = cm.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness >= brightestValue) {
          brightestValue = pixelBrightness;
          
          xpos = i;
          ypos = j; 
          pct = 0.0;
          currR = int(red(pixelColor)); currG = int(green(pixelColor)); currB = int(blue(pixelColor));
        }

        if (pixelBrightness <= dimValue) {
          dimValue = pixelBrightness;
          
          xdim = i;
          ydim = j;          

        }
        
          index++;

        }
      
      }
    
      dObject.update();     
      //changes size of objects at brightest point
      dObject.getLine(xPosArr);

    
      } else {
        
      //set position, i think  
      dObject.updateCurve(this_width,this_height);  
 
      //set color based on the previous
      int index = int((ypos*this_width)+xpos) > this_width*this_height ? 0 : int((ypos*this_width)+xpos);      
      pixelColor = cm.pixels[index];
      
      currR = int(red(pixelColor)); currG = int(green(pixelColor)); currB = int(blue(pixelColor));    
 
      //add data
      dObject.update();     
  
      dObject.printCurve();
 
    }   
  } else {
      
      dObject.update();     
   
  }  
        
    if (newFrame)
    {
      newFrame=false;
      //image(videocam,0,0,width,height);
      blobImg.copy(videocam, 0, 0, videocam.width, videocam.height, 
          0, 0, blobImg.width, blobImg.height);
      fastblur(blobImg, 2);
      theBlobDetection.computeBlobs(blobImg.pixels);
      dObject.drawLine(xPosArr);
      //DEBUG drawBlobsAndEdges(true,true);
    }
  
}



// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(3);
        stroke(0,255,0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
              eA.x*width, eA.y*height, 
              eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255,0,0);
        rect(
          b.xMin*width,b.yMin*height,
          b.w*width,b.h*height
          );
      }

    }

      }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}

void mousePressed() {
  if(streamFrame.equals("on")) {
      streamFrame ="off";
  } else {
      streamFrame ="on";
  }
}