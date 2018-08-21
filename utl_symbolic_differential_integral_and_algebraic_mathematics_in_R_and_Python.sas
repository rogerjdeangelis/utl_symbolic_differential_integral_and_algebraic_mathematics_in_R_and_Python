Symbolic differential, integral and algebraic mathematics in Python


     1. Expand (x+y)**2 * (x+1)
           x**3 + 2*x**2*y + x**2 + x*y**2 + 2*x*y + y**2

     2. Simplify (x+y)**2 * (x+1)
           sin(x)

     3. Solve  (x**3 + 2*x**2 + 4*x + 8, x)
           [-2i, 2i, -2]

     4. Solve
           solve([Eq(x + 5*y, 2), Eq(-3*x + 6*y, 15)], [x, y])
           x=-1
           y=+1

     5. Limit sin(x)-x)/x**3, as x goes to 0
           -1/6

     6. Derivative cos(x**2)**2 / (1+x)
           -4*x*sin(x**2)*cos(x**2)/(x + 1) - cos(x**2)**2/(x + 1)**2

     7. integral  x**2 * cos(x)
           x**2*sin(x) + 2*x*cos(x) - 2*sin(x)


INPUT
=====

  All expressions are internal to Python


OUTPUT
======

  1. x**3 + 2*x**2*y + x**2 + x*y**2 + 2*x*y + y**2
  2. sin(x)
  3. [-2*I, 2*I, -2]
  4. {x: -3, y: 1}
  5. -1/6
  6. -4*x*sin(x**2)*cos(x**2)/(x + 1) - cos(x**2)**2/(x + 1)**2
  7. x**2*sin(x) + 2*x*cos(x) - 2*sin(x)


PROCESS
=======

%utl_submit_py64("
from sympy import *;
x, y, z, t = symbols('x y z t');
r=( (x+y)**2 * (x+1) ).expand();
print r;
a = 1/x + (x*sin(x) - 1)/x;
s=simplify(a);
print s;
z=solve(x**3 + 2*x**2 + 4*x + 8, x);
print z;
s=solve([Eq(x + 5*y, 2), Eq(-3*x + 6*y, 15)], [x, y]);
print s;
l=limit((sin(x)-x)/x**3, x, 0);
print l;
d=diff(cos(x**2)**2 / (1+x), x);
print d;
i=integrate(x**2 * cos(x), x);
print i;
");

/* all data internal */


%macro utl_submit_py64(
      pgm
     ,return=  /* name for the macro variable from Python */
     )/des="Semi colon separated set of python commands - drop down to python";

  * write the program to a temporary file;
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $1024;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'));
        if cmd=:'. ' then
           cmd=trim(substr(cmd,2));
         put cmd $char384.;
         putlog cmd $char384.;
      end;
  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %put &_loc;
  filename rut pipe  "C:\Python_27_64bit/python.exe &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename py_pgm clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "*******  " _infile_;
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_py64;

