public class Boid{
 
  //Assigns a boid with a start position
  PVector loc = new PVector( random( -200, width ), random( -200, height ), random( -400, -450 ) ); 
 
  PVector velocity = new PVector();//The boids have no velocity at the start
   
  float maxspeed = 5.0;//Makes the boids fly slower than a velocity magnitude of 5
  int size = 100; // Size of a boid
  int desiredseperation=size/2; // Boids keep a distance of half their sizes from eachother
  int r=200;// Later used for broadening the borders by 'r'


//Function for the behaviour of the deviant bird
public void thatWeirdBoid(float x, float y, float z, int chance){ 

    PVector randomdir= new PVector(); //Vector for the direction taken by the deviant boid.
 
  /*Each boid has a chance of [6/('chance'+boids.length)] for making a deviation.
  That is a very small chance and this is necessary because there can not be more 
  than one boid in the group that deviates, and it should not happen in every frame. 
  Otherwise the movements will be too chaotic.
 
  When a coordinate does happen to deviate, it is in a range from 0 to 2, 
  All deviations are stored in the randomdir vector
 */
    if(x<-chance)    randomdir.x=x+chance;
    if(x>chance)     randomdir.x=x-chance;  
   
    if(y<-chance)    randomdir.y=y+chance;  
    if(y>chance)     randomdir.y=y-chance;
    
    if(z<-chance)    randomdir.z=z+chance;    
    if(z>chance)     randomdir.z=z-chance;
    
    //The deviating vector is added to the velocity of the boid, so that it changes direction
    velocity.add( randomdir );
    //Makes sure the magnitude of the velocity does not get too high
    velocity.limit(maxspeed);
    // The new velocity is added to the location
    loc.add(velocity);
    
borders();  
display();

}




public void thatConformistBoid(){    
   float distance;   
   
   //for seperation
   PVector sum = new PVector();
   int count = 0;//To keep track of how many boids are close
   
      //Compare this boid to the other boids in the array
      for (Boid other : boids){ 
       //Calculate the distance from this boid to all the other boids
       distance = PVector.dist(loc, other.loc); 
         
        // If a boid is close but not too close: 
        if (distance > desiredseperation && distance< size*10){ 
          
          if (velocity != other.velocity){ 
            velocity= other.velocity; // If a neighbouring boid has  a different velocity than this boid, it copies its neighbours velocity.
          } 
          
        if (distance > 0 && distance <= desiredseperation){ //For boids that are too close by, but not the boid itself (distance>0)
          PVector diff = PVector.sub(loc, other.loc);  // Calculates a PVector pointing away from the other’s location
          
          diff.normalize();//Makes the vector a unit vector
          diff.div(distance);// The closer the other boid is, the more this boid should flee. The farther the less. So diff is divided by the distance to weigh it appropriately.
          
          sum.add(diff);// Add all the vectors together
          count++; // Increment the count of how many boids are too close by.
          } 
        
   if (count > 0) { //When no boids are too close by, do nothing.
   
      sum.div(count); //The direction the  boid wants to flee in, is the average of all the vectors pointing away from other's locations.
                      //So we have to divide the total vector by the number of boids that are too close.
      sum.normalize(); //Makes the vector a unit vector
      velocity = sum; //Changes the original velocity into the fleeing vector
      }
   }
}


loc.add(velocity);
borders();
display();
   
}



   
public void borders() {
  // With the 3D perspective, simply defining borders by width and height is not enough. When z increases, the perspective makes the y-axis move to the right, and the x-axis move downwards. 
  // To compensate for this, and display the boids in a way that they are visible I have made some changes in the borders:
  // In the x direction, de borders are moved to the left 
    if (loc.x < -r) loc.x = width-r;
    if (loc.y < -r) loc.y = height-r;
    
  // In the y direction, the borders are moved up
    if (loc.x > width-r) loc.x = -r;
    if (loc.y > height-r) loc.y = -r;
    
  // In the z direction, boids can not get too close by or to far away, so that they remain visible  
    if (loc.z > -400) loc.z = -400;
    if (loc.z < -450) loc.z = -450;
  }

     
     
     
public void display(){ //This function visualizes the boids
   
   translate( loc.x, loc.y, loc.z );//Each boid is displayed in its new location
    //The boids are constructed by two triangles, that connect at their base. 
    //In that way, the boids look like birds that point their wings upwards.
    beginShape( TRIANGLES ); 
    // A boid in the middle of the screen looks like a V, 
    //and boids that fly in different directions look different
    vertex( 0, size, size/2);
    vertex( -size/2, 0, 0);
    vertex( 0, size, -size/2);
    
    vertex( 0, size, size/2 );
    vertex( size/2, 0, 0);
    vertex( 0, size, -size/2);
    endShape(); } 

}