public enum MenuOption
{
  QUIT,
  START
}

class PieMenu
{
  PImage backgroundImage;
    
  String[] options = { "Quit", "Start"};
  
  float diam;
  
  float textdiam;
  
  JoypadManager joyManager;
  
  MenuOption currentOption;

  PieMenu(JoypadManager pJoyManager)
  {
    textAlign(CENTER, CENTER);
    noStroke();
    smooth();
    diam = min(width, height) * 0.8;
    textdiam = diam/2.75;
    this.joyManager = pJoyManager;
    
    this.backgroundImage = loadImage("./data/MenuBackground.jpg");
    
    this.currentOption = MenuOption.START;
  }
   
  void draw() 
  {
    background(this.backgroundImage);
    
    this.update();
  }
  
  void update()
  {
    fill(255,255,255,0);
    ellipse(width/2, height/2, diam+3, diam+3);
    
    float piTheta = this.joyManager.getRightJoy().y >= 0 ? 2 : 5;
    float op = options.length/TWO_PI;

    for (int i=0; i<options.length; i++) 
    {
      float s = (i/op-PI*0.50) + PI /2;
      float e = ((i+0.99)/op-PI*0.50) + PI /2;
      
      if (piTheta>= s && piTheta <= e) 
      {
        fill(100, 0, 200,100);
        currentOption = i == 0 ? MenuOption.QUIT : MenuOption.START;
      } 
      else
      {
        fill(255,255,255,100);
      }
      arc(width/2, height/2, diam, diam, s, e);
    }
   
    fill(0);
    for (int i=0; i<options.length; i++) {
      float m = i/op + PI /2;
      fill(255);
      stroke(color(0,0,0));
      textSize(32);
      text(options[i], width/2+cos(m)*textdiam, height/2+sin(m)*textdiam);
    }
   
    fill(125);
    ellipse(width/2, height/2, 50, 50);
  }
  
  MenuOption getCurrentOption()
  {
    return this.currentOption;
  }
}