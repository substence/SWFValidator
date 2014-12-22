/**
 * @author: eketcham
 * Re-created in AS3 from JS.
 * Source: http://www.mymessedupmind.co.uk/index.php/javascript-k-mean-algorithm
 */
package com.cc.utils
{
    public class Kmeans
    {
        public static function proccessClusters( arrayToProcess:Array, clusters:int ) : Array
        {
            var groups:Array = [];
            var centroids:Array = [];
            var oldCentroids:Array = [];
            var changed:Boolean = true;
            
            // order the input array
            arrayToProcess.sort( Array.NUMERIC );
            
            // initialise group arrays
            for( var initGroups:int = 0; initGroups < clusters; initGroups++ )
            {
                groups[ initGroups ] = [];
            }  
            
            // pick initial centroids
            var initialCentroids:int = Math.round( arrayToProcess.length / ( clusters + 1 ) );
            for( var i:uint = 0; i < clusters; i++ )
            {
                centroids[ i ] = arrayToProcess[ ( initialCentroids * ( i + 1 ) ) ];
            }
            
            // Sort input list into clusters
            while( changed == true )
            {
                for( var j:uint = 0; j < clusters; j++ )
                {
                    groups[ j ] = [];
                }
                
                changed = false;
                
                for ( var k:uint = 0; k < arrayToProcess.length; k++ )
                {
                    var distance:int = -1;
                    var oldDistance:int = -1;
                    var newGroup:int;
                        
                    for ( var l:uint = 0; l < clusters; l++ )
                    {   
                        distance = Math.abs( centroids[ l ] - arrayToProcess[ k ] );	
                        
                        if ( oldDistance == -1 )
                        {   
                            oldDistance = distance;
                            newGroup = l;   
                        }
                        else if ( distance <= oldDistance )
                        {
                            newGroup = l;
                            oldDistance = distance;   
                        }
                    }	
                    
                    groups[ newGroup ].push( arrayToProcess[ k ] );	  
                }
                
                oldCentroids = centroids;
                
                for ( var m:uint = 0; j < clusters; j++ )
                {
                    var total:int = 0;
                    var newCentroid:int = 0;
                    
                    for( var n:uint = 0; n < groups[ m ].length; n++ )
                    {
                        total += groups[ m ][ n ];
                    }
                    
                    newCentroid = total / groups[ newGroup ].length;  
                    
                    centroids[ m ] = newCentroid;
                }
                
                for( var o:uint = 0; o < clusters; o++ )
                {   
                    if ( centroids[ o ] != oldCentroids[ o ] )
                    {   
                        changed = true;
                    }
                }
            }
            
            return groups;
        } 
    }
}