import java.util.Random;

//Enum representing oypad colors
public enum Colors
{
  NONE,
  BLUE,
  GREEN,
  RED,
  YELLOW
}

//Static class used to create color and additive colors
public static class ColorMaker
{
  //Used to generate random numbers
  private static final Random randomGenerator = new Random();
  
  //Color value when creating color
  private static final int colorValue = 255;
  
  //Return ArrayList of colors
  public static ArrayList<Colors> getColors()
  {
    ArrayList<Colors> allColors = new ArrayList<Colors>();
    
    allColors.add(Colors.NONE);
    allColors.add(Colors.BLUE);
    allColors.add(Colors.GREEN);
    allColors.add(Colors.RED);
    //allColors.add(Colors.YELLOW);
    
    return allColors;  
  }
  
  //Return color blue as a PVector
  public static PVector getBlue()
  {
    return new PVector(0,0,colorValue);
  }
  
  //Return color green as a PVector
  public static PVector getGreen()
  {
    return new PVector(0,colorValue,0);
  }
  
  //Return color red as a PVector
  public static PVector getRed()
  {
    return new PVector(colorValue,0,0);
  }
  
  //Return a addition of two random colors
  public static PVector getRandomAdditiveColor()
  {
    ArrayList<Colors> colors = getColors();
    int size = colors.size();
    
    int firstColor = randomGenerator.nextInt(size*2);
    int secondColor = randomGenerator.nextInt(size*2);
    
    
    ArrayList<Colors> addition = new ArrayList<Colors>();
    addition.add(firstColor <= size/3 ? Colors.NONE : getColors().get(firstColor%size));
    addition.add(secondColor <= size/3 ? Colors.NONE : getColors().get(secondColor%size));
    
    while(addition.get(0) == addition.get(1))
      addition.set(0,colors.get(randomGenerator.nextInt(size-1)+1));
      
    if(addition.contains(Colors.YELLOW))
      addition.set((addition.indexOf(Colors.YELLOW)+1)%2,Colors.NONE);
    
    return colorAddition(addition);
  }
  
  //Add N colors and return a PVector containing the result
  public static PVector colorAddition(ArrayList<Colors> colors)
  {
    PVector additiveColors = new PVector(0,0,0);
    for(int i=0;i<colors.size();i++)
    {
      switch(colors.get(i))
      {
        case BLUE:
          additiveColors.add(getBlue());
          break; 
        case GREEN:
          additiveColors.add(getGreen());
          break;
        case RED:
          additiveColors.add(getRed());
          break;
        case YELLOW:
          ArrayList<Colors> addition = new ArrayList<Colors>();
          addition.add(Colors.RED);
          addition.add(Colors.GREEN);
          
          additiveColors.add(colorAddition(addition));
          break;
        default:
          break;
      }
    }
    return additiveColors;
  }
}