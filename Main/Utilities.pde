static class Utilities
{
  
  public static PVector arrayToPVector(float[] array)
  {
     if(array.length == 3)
       return new PVector(array[0],array[1],array[2]);
       
     return new PVector(0,0,0);
  }
  
  public static float PVectorSum(PVector v1)
  {
    return v1.x + v1.y + v1.z;
  }
  
  public static PVector PVectorMult(PVector v1, PVector v2)
  {
    return new PVector(v1.x*v2.x,v1.y*v2.y,v1.z*v2.z);
  }
  
  public static PVector PVectorDiv(PVector v1, PVector v2)
  {
    return new PVector(v1.x/v2.x,v1.y/v2.y,v1.z/v2.z);
  }
  
}