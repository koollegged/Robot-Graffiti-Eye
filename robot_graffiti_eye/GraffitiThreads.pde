class DrawParamThread extends Thread {
 
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String[] drawParams;
  boolean available;           // Is the thread available?  Yes or no?  
  int count;   // counter
  String paramAddress;
  
  // Constructor, create the thread
  // It is not running by default
  DrawParamThread (int w) {
    wait = w;
    running = false;
    available = false;
    count = 0;
  //online  
  //paramAddress = "http://www.createcreate.us/exquisite-corpse/source/get_data_db.php"; 
  //ofline mode
  paramAddress = "offline.txt"; 

    
  }

  // Overriding "start()"
  void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }
 
 
  // We must implement run, this gets triggered by start()
  void run () {
    while (running) {
         drawParams = loadStrings(paramAddress);
         //println(drawParams[1]);
         available = true;

      try {
        // Wait five seconds
        sleep((long)(wait));    
        } 
      catch (Exception e){
      available = false; 
      }
    }
  }
    
 
  boolean available() {
    return available;
  } 
  
  String[] getDrawParams() {
    return drawParams;
  } 
 
  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }  
}



/*
class MMThread extends Thread {
 
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  boolean available;           // Is the thread available?  Yes or no?  
  int count;                 // counter
  //move setting
  GSMovie movie;
  GSMovieMaker mm;  
 
  // Constructor, create the thread
  // It is not running by default
  MMThread () {
    running = false;
    available = false;
    count = 0;

  }
  
  // Overriding "start()"
  void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting recording"); 
    // Do whatever start does in Thread, don't forget this!
     //movie setup
     mm = new GSMovieMaker(pen_circleline.this, width, height, "drawing.ogg", GSMovieMaker.THEORA, GSMovieMaker.BEST, 4);  
     mm.setQueueSize(50, 10);
     mm.start();
    super.start();

  }
 
 
  // We must implement run, this gets triggered by start()
  void run () {
    while (running) {
    
      available = true;
      try {
        // Wait five seconds
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }

  }
 
  boolean available() {
    return available;
  } 
  
  void document() {
      //write movie
      loadPixels();
      mm.addFrame(pixels);         // New data is available!
 } 

  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }  
}
*/