Problem: Using sentinels to restrict update to common columns in master table ana transaction table             
                                                                                                                
This is a useful 'out of the box' technique originally by Mike Keintz.                                          
This techniques has mamy PDV restructuring applications.                                                        
                                                                                                                
This is realted to, but is a different problem.                                                                 
                                                                                                                
    Two Solutions                                                                                               
       1. Example using sentinels (Mark Keintzths may not be the best example)                                  
       2. Using varlist macro                                                                                   
                                                                                                                
see                                                                                                             
https://tinyurl.com/y92kuyaj                                                                                    
https://communities.sas.com/t5/SAS-Programming/Merging-and-keeping-only-common-variables/m-p/519254             
                                                                                                                
Mark Keintz profile                                                                                             
https://communities.sas.com/t5/user/viewprofilepage/user-id/31461                                               
                                                                                                                
                                                                                                                
INPUT                                                                                                           
=====                     |  Update only A & B using transaction below                                          
                          |                                                                                     
 WORK.MASTER total obs=2  |    RESULTING TABLE                                                                  
                          |                                                                                     
   A    B    C    D       |   A    B    C    D                                                                  
                          |                                                                                     
   0    0    0    0       |   8    3    0    0                                                                  
   0    0    0    0       |   8    4    0    0                                                                  
                                                                                                                
                                                                                                                
 WORK.TRANSACTION total obs=2                                                                                   
                                                                                                                
   X    B    Y    A    Z                                                                                        
                                                                                                                
   1    3    6    8    5                                                                                        
   2    4    7    8    4                                                                                        
                                                                                                                
                                                                                                                
EXAMPLE OUTPUT  (X, Y and Z are dropped)                                                                        
----------------------------------------                                                                        
                                                                                                                
 WORK.WANT total obs=2                                                                                          
                                                                                                                
   A    B    C    D                                                                                             
                                                                                                                
   8    3    0    0                                                                                             
   8    4    0    0                                                                                             
                                                                                                                
                                                                                                                
PROCESS                                                                                                         
=======                                                                                                         
                                                                                                                
1. Example using sentinels (demo - may not be the best example)                                                 
---------------------------------------------------------------                                                 
                                                                                                                
data  want;                                                                                                     
  if 0 then set master;         /*Start the PDV with the  vars*/                                                
  retain _sentinel_START .;     /*Append this var to the PDV */                                                 
  merge master transaction ;    /*OVERWRITE COMMON VARIABLES */                                                 
  retain _sentinel_end .;       /*Append a final var to the PDV*/                                               
  drop _sentinel_start -- _sentinel_end;                                                                        
run;quit;                                                                                                       
                                                                                                                
                                                                                                                
Before we drop sentinel_start -- _sentinel_end;                                                                 
                                                                                                                
                           _SENTINEL_                   _SENTINEL_                                              
Obs    A    B    C    D      START       X    Y    Z       END                                                  
                                                                                                                
 1     8    3    0    0         .        1    6    5         .                                                  
 2     8    4    0    0         .        2    7    4         .                                                  
                                                                                                                
                                                                                                                
2. Using varlist macro                                                                                          
----------------------                                                                                          
                                                                                                                
  data want;                                                                                                    
    keep %utl_varlist(master);                                                                                  
    merge master transaction;                                                                                   
  run;quit;                                                                                                     
                                                                                                                
                                                                                                                
OUTPUT                                                                                                          
======                                                                                                          
                                                                                                                
 WORK.WANT total obs=2                                                                                          
                                                                                                                
  A    B    C    D                                                                                              
                                                                                                                
  8    3    0    0                                                                                              
  8    4    0    0                                                                                              
                                                                                                                
*                _              _       _                                                                       
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _                                                                
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |                                                               
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |                                                               
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|                                                               
                                                                                                                
;                                                                                                               
                                                                                                                
* template will not be in output;                                                                               
data master;                                                                                                    
 input a  b c d;                                                                                                
cards4;                                                                                                         
0 0 0 0                                                                                                         
0 0 0 0                                                                                                         
;;;;                                                                                                            
run;quit;                                                                                                       
                                                                                                                
                                                                                                                
data transaction;                                                                                               
 input x b y a z;                                                                                               
cards4;                                                                                                         
1 3 6 8 5                                                                                                       
2 4 7 8 4                                                                                                       
;;;;                                                                                                            
run;quit;                                                                                                       
                                                                                                                
                                                                                                                
