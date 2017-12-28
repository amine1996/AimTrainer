import damkjer.ocd.*;

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

PShape sphere;
final float sphereRadius = 300;
final PVector spherePos = new PVector(0,10,0);

damkjer.ocd.Camera camPlayer;
damkjer.ocd.Camera camSpectator;
damkjer.ocd.Camera mainCam;

float joyX, joyY, joyRX, joyRY, rt;

PImage skyDome;

ControlIO control;
ControlDevice stick;

void setup()
{
  size(displayWidth, displayHeight, P3D); 

  skyDome = loadImage("./data/Sky019.jpg");
  
  sphereDetail(100);
  noStroke();
  sphere = createShape(SPHERE,sphereRadius);
  sphere.setTexture(skyDome);
  
  control = ControlIO.getInstance(this);
  stick = control.getMatchedDeviceSilent("joystick");
  
  PVector posPlayer = new PVector(0,0,0);
  PVector targetPlayer = new PVector(0,0,-sphereRadius/2);
  PVector upVectorPlayer = new PVector(0,1,0);
  camPlayer = createCamera(posPlayer,targetPlayer,upVectorPlayer,70,1,1000);
  
  PVector posSpectator = new PVector(0,-sphereRadius/2,0);
  PVector targetSpectator = new PVector(0,0,0.0001);
  PVector upVectorSpectator = new PVector(0,1,0);
  camSpectator = createCamera(posSpectator, targetSpectator,upVectorSpectator,70,1,1000);
 
 
  mainCam = camPlayer;
}

damkjer.ocd.Camera createCamera(PVector pos, PVector target, PVector upVector, float fov, float near, float far)
{
  return new damkjer.ocd.Camera(this,pos.x,pos.y,pos.z,target.x,target.y,target.z,upVector.x,upVector.y,upVector.z,fov,near,far);
}

void draw()
{
  background(100,100,100);

  if(stick != null)
  {
    joyX = map(stick.getSlider("X").getValue(), -1, 1, -1, 1);
    joyY = map(stick.getSlider("Y").getValue(), -1, 1, -1, 1);
    joyRX = map(stick.getSlider("RX").getValue(), -1 , 1, -1, 1);
    joyRY = map(stick.getSlider("RY").getValue(), -1, 1, -1, 1);

    rt = map(stick.getSlider("RT").getValue(), -1, 1, -1, 1);
      
    //Translation
    if(abs(joyX) > 0.1 || abs(joyY) > 0.1)
    {
      PVector oldTarget = arrayToPVector(camPlayer.target());
      PVector oldPos = arrayToPVector(camPlayer.position());
      
      camPlayer.truck(joyX);
      camPlayer.dolly(joyY); 
        
      PVector newPos = arrayToPVector(camPlayer.position());
      
      if((( spherePos.x-newPos.x )*( spherePos.x-newPos.x ) + (spherePos.y-newPos.y)*(spherePos.y-newPos.y) + (spherePos.z-newPos.z)*(spherePos.z-newPos.z)) < ((sphereRadius - 20) * (sphereRadius - 20)) )
      {        
        PVector newTarget = arrayToPVector(camPlayer.target());
        camPlayer.jump(newPos.x,0,newPos.z);
        camPlayer.aim(newTarget.x,oldTarget.y,newTarget.z);
      }
      else{
        camPlayer.truck(-joyX);
        camPlayer.dolly(-joyY); 
      }
    }
    
    //Camera sight
    if(abs(joyRX) > 0.1 || abs(joyRY) > 0.1)
    { 
      float angleX = radians(joyRX) * 2.0;
      float angleY = radians(joyRY) * 2.0;
      
      camPlayer.pan(angleX);
      camPlayer.tilt(angleY);
    }
    
    // Shoot
    if (rt > 0) {
      float[] position = camPlayer.position();
      println("Position X: " + position[0]);
      println("Position Y: " + position[1]);
      println("Position Z: " + position[2]);
      
      float[] target = camPlayer.target();
      println("Target X: " + target[0]);
      println("Target Y: " + target[1]);
      println("Target Z: " + target[2]);
      
      // Récupérer un tableau de cibles avec coordonnée (x, y, z)
      // foeach(cibles as cible) {
      //   deltaZ = abs(cible.z - position.z)
      //   espilon = abs(cible.z - position.z) / abs(maxZ - position.z) * COEFF // définir le coeff en testant...
      //
      //   if (abs(cible.x - position.x) <= espilon && abs(cible.y - position.y) <= espilon) {
      //     // Cible touchée
      //     // Incrémenter le score et détruire la cible
      //    }
      // }
    }
  }
  
  PVector attitude = arrayToPVector(camPlayer.attitude());
  PVector pos = arrayToPVector(camPlayer.position());
   
  //Cube that represent camera
  pushMatrix();
    translate(0,0,0);
    //rotateY(attitude.x);
    //rotateX(attitude.z);
    drawCube();
  popMatrix();
  
  pushMatrix();
    translate(spherePos.x,spherePos.y,spherePos.z);
    shape(sphere);
  popMatrix();
  
   //Affiche le flux de la main cam
  mainCam.feed();
  
  pushMatrix();
    //Positionne la croix sur la caméra //<>//
    translate(pos.x, pos.y, pos.z);
    //Rotation par rapport à l'axe Y
    rotateY(attitude.x);  
    //Rotation par rapport à l'axe X
    rotateX(-attitude.y);
    //Pousse la croix de 10 en Z //<>//
    translate(0, 0, -2);
  
    //Dessine la croix //<>//
    fill(0);
    stroke(255,0,0);
    strokeWeight(1); //<>//
    line(-0.1,0,0.1,0);
    line(0,-0.1,0,0.1);
  popMatrix();
  
  pushMatrix();
    fill(255); //<>//
    translate(0,10,0);
    rotateX(radians(90));
    ellipse(0,0,sphereRadius*2,sphereRadius*2);
  popMatrix();
}

PVector arrayToPVector(float[] array)
{
   if(array.length == 3)
     return new PVector(array[0],array[1],array[2]);
     
   return new PVector(0,0,0);
}

void drawCube()
{
  noStroke();
  // Front
  beginShape(QUADS);
  fill(255,0,0);
  vertex(-1, -1,  1);
  vertex( 1, -1,  1);
  vertex( 1,  1,  1);
  vertex(-1,  1,  1);
  endShape();
  // Back
  beginShape(QUADS);
  fill(255,255,0);
  vertex( 1, -1, -1);
  vertex(-1, -1, -1);
  vertex(-1,  1, -1);
  vertex( 1,  1, -1);
  endShape();
  // Bottom
  beginShape(QUADS);
  fill( 255,0,255);
  vertex(-1,  1,  1);
  vertex( 1,  1,  1);
  vertex( 1,  1, -1);
  vertex(-1,  1, -1);
  endShape();
  // Top
  beginShape(QUADS);
  fill(0,255,0);
  vertex(-1, -1, -1);
  vertex( 1, -1, -1);
  vertex( 1, -1,  1);
  vertex(-1, -1,  1);
  endShape();
  // Right
  beginShape(QUADS);
  fill(0,0,255);
  vertex( 1, -1,  1);
  vertex( 1, -1, -1);
  vertex( 1,  1, -1);
  vertex( 1,  1,  1);
  endShape();
  // Left
  beginShape(QUADS);
  fill(0,255,255);
  vertex(-1, -1, -1);
  vertex(-1, -1,  1);
  vertex(-1,  1,  1);
  vertex(-1,  1, -1);
  endShape();
}

void keyPressed()
{
  if(key == 'a')
  {
    mainCam = camPlayer;
  }
  if(key == 'e')
  {
    mainCam = camSpectator;
  }
  if(key == CODED)
  {
    if(keyCode == UP)
    {
      if(mainCam == camPlayer)
        camPlayer.tilt(radians(1) * 2.0);
      else if(mainCam == camSpectator)
        camSpectator.jump(camSpectator.position()[0],camSpectator.position()[1]+5,camSpectator.position()[2]);
    }
    if(keyCode == DOWN)
    {
      if(mainCam == camPlayer)
        camPlayer.tilt(radians(1) * 2.0);
      else if(mainCam == camSpectator)
        camSpectator.jump(camSpectator.position()[0],camSpectator.position()[1]-5,camSpectator.position()[2]);
    }
    if(keyCode == LEFT)
    {
      camPlayer.pan(radians(1) * 2.0);
    }
    if(keyCode == RIGHT)
    {
      camPlayer.pan(radians(1) * 2.0);
    }
  }
}