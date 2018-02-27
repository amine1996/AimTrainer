//Utility functions for PVectors
static class Utilities
{
  //Take an array of float and convert it to a PVector
  public static PVector arrayToPVector(float[] array)
  {
     if(array.length == 3)
       return new PVector(array[0],array[1],array[2]);
       
     return new PVector(0,0,0);
  }
  
  //Sum a PVector and returns the result
  public static float PVectorSum(PVector v1)
  {
    return v1.x + v1.y + v1.z;
  }
  
  //Product term by term of two PVectors
  public static PVector PVectorMult(PVector v1, PVector v2)
  {
    return new PVector(v1.x*v2.x,v1.y*v2.y,v1.z*v2.z);
  }
  
  //Division term by term of two PVector
  public static PVector PVectorDiv(PVector v1, PVector v2)
  {
    return new PVector(v1.x/v2.x,v1.y/v2.y,v1.z/v2.z);
  }
  
}