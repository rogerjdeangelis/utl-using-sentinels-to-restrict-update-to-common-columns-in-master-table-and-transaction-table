Problem: Using sentinels to restrict update to common columns in master table ana transaction table             
                                                                                                                
This is a useful 'out of the box' technique originally by Mike Keintz and Paul Dorfman.                                          
This techniques has mamy PDV restructuring applications.      

Good Catch by Mark  (see more details on end)

I first got the notion of using SENTINEL variables as PDV location markers from a posting by Paul Dorfman,       
but I believe the objective was something other than generating a data set of common variables.                  
And actually the term COMMON is a bit misleading in my code that you sent out.                                   
It really only avoids adding variables from the transaction data set that are not already in the master data set.
Any variable that is only in the master is not fully "common" but is nevertheless written to the output.         
                                                                                                                 
My solution does not apply to the original problem and should not use the term 'common'..                        
My solutions  does not keep 'common' variables but updates and drops variables                                   
in the trasaction that are  not in the master.                                                                   
All variables in the master are kept.                                                                            
                                                                                                                 

                                                                                                                
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


see additional solutions and useful comments by Mark on the end                                                         
                                                                                                                        
*__  __            _                                                                                                    
|  \/  | __ _ _ __| | __                                                                                                
| |\/| |/ _` | '__| |/ /                                                                                                
| |  | | (_| | |  |   <                                                                                                 
|_|  |_|\__,_|_|  |_|\_\                                                                                                
                                                                                                                        
;                                                                                                                       
                                                                                                                        
My solution does not apply to the original problem.                                                                     
My solutions  does not keep 'common' variables but updates and drops variables                                          
in the trasaction that are  not in the master.                                                                          
All variables in the master are kept.                                                                                   
                                                                                                                        
I first got the notion of using SENTINEL variables as PDV location markers from a posting by Paul Dorfman,              
but I believe the objective was something other than generating a data set of common variables.                         
And actually the term COMMON is a bit misleading in my code that you sent out.                                          
It really only avoids adding variables from the transaction data set that are not already in the master data set.       
Any variable that is only in the master is not fully "common" but is nevertheless written to the output.                
                                                                                                                        
                                                                                                                        
                                                                                                                        
To get just truly common vars is a bit trickier.  Imagine data sets:                                                    
                                                                                                                        
   orig_a with vars  ID A B P X Y                                                                                       
                                                                                                                        
   orig_b with vars  ID A B Q X Z                                                                                       
                                                                                                                        
   orig_c  with vars ID A B R Y Z                                                                                       
                                                                                                                        
                                                                                                                        
                                                                                                                        
Unlike the “master data set variables only” task,  a merge-by-id                                                        
keeping only the truly common variables (ID A  B) can't be done in a single data step.                                  
Instead you need to make templates (0 obs) _NOT_INA  and _NOT_INB in trivial precursor data steps.                      
These two data sets will have all the non-common variables, making getting                                              
the common variables in a final data step easy.  For three datasets this easily                                         
macro-ized code would do the trick:                                                                                     
                                                                                                                        
                                                                                                                        
data orig_a;                                                                                                            
  input  id a b p x y;                                                                                                  
datalines;                                                                                                              
1     111   121   131   161   171                                                                                       
2     112   122   132   162   172                                                                                       
3     113   123   133   163   173                                                                                       
5     115   125   135   165   175                                                                                       
run;                                                                                                                    
data orig_b;                                                                                                            
input id a b  q x z ;                                                                                                   
datalines;                                                                                                              
1     211   221   241   261   281                                                                                       
2     212   222   242   262   282                                                                                       
4     214   224   244   264   284                                                                                       
6     216   226   246   266   286                                                                                       
run;                                                                                                                    
data orig_c;                                                                                                            
  input  id a b  r y z ;                                                                                                
datalines;                                                                                                              
1     311   321   351   371   381                                                                                       
3     313   323   353   373   383                                                                                       
4     314   324   354   374   384                                                                                       
7     317   327   357   377   387                                                                                       
run;                                                                                                                    
                                                                                                                        
data _not_ina (drop=_sentinel:);                                                                                        
  if 0 then set orig_a;                                                                                                 
  retain _sentinel1 .;                                                                                                  
  if 0 then set orig_: ;                                                                                                
  retain _sentinel2 .;                                                                                                  
  keep _sentinel1 -- _sentinel2;                                                                                        
  stop;                                                                                                                 
run;                                                                                                                    
                                                                                                                        
data _not_inb (drop=_sentinel:);                                                                                        
  if 0 then set orig_b;                                                                                                 
  retain _sentinel1 .;                                                                                                  
  if 0 then set orig_: ;                                                                                                
  retain _sentinel2 .;                                                                                                  
  keep _sentinel1 -- _sentinel2;                                                                                        
  stop;                                                                                                                 
run;                                                                                                                    
                                                                                                                        
data _not_inc (drop=_sentinel:);                                                                                        
  if 0 then set orig_c;                                                                                                 
  retain _sentinel1 .;                                                                                                  
  if 0 then set orig_: ;                                                                                                
  retain _sentinel2 .;                                                                                                  
  keep _sentinel1 -- _sentinel2;                                                                                        
  stop;                                                                                                                 
run;                                                                                                                    
                                                                                                                        
data common (drop=_sentinel1--_sentinel2);                                                                              
  retain _sentinel1 . ;                                                                                                 
  if 0 then set _not_in: ;                                                                                              
  retain _sentinel2 . ;                                                                                                 
  merge orig_: ;                                                                                                        
  by id;                                                                                                                
run;                                                                                                                    
                                                                                                                        
                                                                                                                        
BTW, when starting with only 2 data  sets, one could instead make ONLY_INA, ONLY_INB                                    
templates with variables exclusive to the eponymous data set, and then substitute them                                  
in the DATA COMMON step above.   But if there are more than 2 starting data sets,                                       
the “ONLY_IN” technique would fail to capture non-common variables                                                      
found in multiple datasets (vars X Y and Z above).                                                                      
                                                                                                                        
                                                                                                                        
                                                                                                                                                                                                                                              
                                                                                                                        
Regards,                                                                                                                
                                                                                                                        
Mark                                                                                                                    
                                                                                                                        

                   
                   
                   
                                                                                                                
