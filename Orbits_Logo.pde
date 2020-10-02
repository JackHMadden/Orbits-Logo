// Planet Orbit Logo  -  Jack Madden 2020 
//
// Data used 
// Orbit Parameters: https://ssd.jpl.nasa.gov/txt/p_elem_t2.txt   and    https://ssd.jpl.nasa.gov/txt/aprx_pos_planets.pdf
// Physical Parameters: https://ssd.jpl.nasa.gov/?planet_phys_par
//
// Check map against here https://space.jpl.nasa.gov/   (Solar System, Above, 2deg)
// Sample Date:  J2000=2451544   Sept.26.2020=2459118   ActualDif=7574  ApproxDif=7574.9  Deviation=0.9   

// Settings  ///////////////////////////////////////////////////////////////////
int s=400;        // Canvas size              (2.5 by 1 pixels) : 400 default //
float scale=80;   // Scaling factor for sizes (pixels) : 80 default           //
float frame=0;    // Number of days ahead     (days) : 0 for today            //
float rate=0.5;   // Days added per frame     (days) : 0.5 for 12 hours       //
////////////////////////////////////////////////////////////////////////////////

// Input Data
float a_mars = 1.5237;      // Mars Semi-major axis    (AU)
float a_earth = 1.0000;     // Earth Semi-major axis   (AU)
float a_venus = 0.7233;     // Venus Semi-major axis   (AU)
float a_mercury = 0.3871;   // Mercury Semi-major axis (AU)
float a_moon = 0.002569*50; // Moon Semi-major axis    (AU * scale factor)

float L_mars = 355.4318684*PI/180+HALF_PI;      // Mars J2000 Mean Longitude    (rad+phase)
float L_earth = 100.46691572*PI/180+HALF_PI;    // Earth J2000 Mean Longitude   (rad+phase)
float L_venus = 181.97970850*PI/180+HALF_PI;    // Venus J2000 Mean Longitude   (rad+phase)
float L_mercury = 252.25166724*PI/180+HALF_PI;  // Mercury J2000 Mean Longitude (rad+phase)
float L_moon = 318.15*PI/180;                   // Moon J2000 Mean Longitude    (rad)

float l_mars = 19140.29934243*PI/180;           // Mars ∆Longitude/∆t    (rad/century)     
float l_earth = 35999.37306329*PI/180;          // Earth ∆Longitude/∆t   (rad/century)  
float l_venus = 58517.81560260*PI/180;          // Venus ∆Longitude/∆t   (rad/century)  
float l_mercury = 149472.67486623*PI/180;       // Mercury ∆Longitude/∆t (rad/century)  
float l_moon = 481266.476*PI/180;               // Moon ∆Longitude/∆t    (rad/century)  

float r_mars = 3389;      // Mars Radius    (km)     
float r_earth = 6371;     // Earth Radius   (km) 
float r_venus = 6051;     // Venus Radius   (km) 
float r_mercury = 2439;   // Mercury Radius (km) 
float r_sun = 695700;     // Sun Radius     (km) 
float r_moon = 1736;      // Moon Radius    (km) 

color c_back = #1e2e3e;    //Background color : #1e2e3e
color c_stroke = #578d9f;  //Stroke color     : #578d9f
color c_font = c_stroke;   //Font color       : c_stroke
color c_mars = #ff7f30;    //Mars color       : #ff7f30
color c_earth = #21c7ff;   //Earth color      : #21c7ff
color c_venus = #f0eb82;   //Venus color      : #f0eb82
color c_mercury = #b4b4b4; //Mercury color    : #b4b4b4
color c_moon = c_mercury;  //Moon color       : c_mercury
color c_sun = #ffd33e;     //Sun color        : #ffd33e

PFont font;                // initialize font
boolean toggleLoop=false;  // initialize draw loop toggling 


void settings(){
  size(int(2.5*s),s,P2D);  // P2D used for smooth lines 
  smooth(8);
}

public void setup(){
  
  // Options
  noLoop();  // set to begin stopped
  frameRate(60);
  strokeWeight(2*(scale/80));
  strokeCap(SQUARE);
  
  // Fonts 
  font = loadFont("AvenirNext-UltraLight-250.vlw"); // crashes when font is loaded in draw loop
}

void draw(){
  
  //Reset canvas
  background(c_back);
  
  // Time calculation
  float daysJ2000=((year()-2000)*365.25 + (30.4375*(month()-1)) + day() + frame ); // Approximates days since J2000  (days)
  float cy=(daysJ2000/365.25/100);                                                 // Converts days to fractions of a century  (centuries)
  println(daysJ2000+" "+cy+" "+frameRate);                                         // Console output ("7580.9375 0.20755476 45.50839")
  
  // Name 
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  textFont(font, scale*1.5);
  fill(c_font);
  noStroke();
  text("JACK", s/2+a_mars*scale*2.2, s/2-a_mars*scale*0.7);
  text("MADDEN", s/2+a_mars*scale*3.57, s/2+a_mars*scale*0.3);
  
  // Sun
  rectMode(CORNER);
  fill(c_sun);
  circle(s/2,s/2,scale*(r_sun/2000000));

  // Mars Circle
  fill(c_mars);
  circle((s/2) + a_mars*scale*cos(L_mars+l_mars*cy),(s/2) - a_mars*scale*sin(L_mars+l_mars*cy),scale*(r_mars/50000));

  // Earth Circle   
  fill(c_earth);
  circle((s/2) + a_earth*scale*cos(L_earth+l_earth*cy),(s/2) - a_earth*scale*sin(L_earth+l_earth*cy),scale*(r_earth/50000));

  // Venus Circle  
  fill(c_venus);
  circle((s/2) + a_venus*scale*cos(L_venus+l_venus*cy),(s/2) - a_venus*scale*sin(L_venus+l_venus*cy),scale*(r_venus/50000));

  // Mercury Circle  
  fill(c_mercury);
  circle((s/2) + a_mercury*scale*cos(L_mercury+(l_mercury*cy)),(s/2) - a_mercury*scale*sin(L_mercury+(l_mercury*cy)),scale*(r_mercury/50000));

  // Moon Circle  
  fill(c_moon);
  circle((s/2) + a_earth*scale*cos(L_earth+l_earth*cy) + a_moon*scale*cos(L_moon+l_moon*cy),(s/2) - a_earth*scale*sin(L_earth+l_earth*cy) - +a_moon*scale*sin(L_moon+l_moon*cy),scale*(r_moon/50000));

  // Orbits 
  noFill();
  stroke(c_stroke);  
  arc(s/2, s/2, a_mars*scale*2, a_mars*scale*2, L_mars-l_mars*cy+PI+0.2, L_mars-l_mars*cy+2*PI+0.2);               // Mars Orbit
  arc(s/2, s/2, a_venus*scale*2, a_venus*scale*2, L_venus-l_venus*cy+PI+0.06, L_venus-l_venus*cy+2*PI+0.06);       // Venus Orbit
  arc(s/2, s/2, a_earth*scale*2, a_earth*scale*2, L_earth-l_earth*cy-0.2, L_earth-l_earth*cy+PI-0.2);              // Earth Orbit
  arc(s/2, s/2, a_mercury*scale*2, a_mercury*scale*2, L_mercury-l_mercury*cy+0.8, L_mercury-l_mercury*cy+PI+0.8);  // Mercury Orbit
  arc((s/2) + a_earth*scale*cos(L_earth+l_earth*cy), (s/2) - a_earth*scale*sin(L_earth+l_earth*cy), a_moon*scale*2, a_moon*scale*2, L_moon-l_moon*cy+HALF_PI+0.2, L_moon-l_moon*cy+PI+HALF_PI+0.2);  // Moon Orbit
  
  frame=frame+rate;   // Advance Frame
}


// Control for pause/play with left mouse button press 
void mousePressed() {
  if (mouseButton == LEFT) {
    if (toggleLoop) { noLoop(); toggleLoop = false; }
    else { loop(); toggleLoop = true; }
  }
}
