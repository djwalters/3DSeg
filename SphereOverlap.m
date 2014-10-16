% Code to calculate the area of intersection between two spheres.
%Exact geometric solution, for checking accuracy of code solutions
%R= radius of larger sphere
%r=radius of smaller sphere
%d=distance between sphere centers
%a=radius of intersection circle

R=50
r=50
d=70.71

a=(1/(2*d))*sqrt(4*d^2*R^2-(d^2-r^2+R^2)^2) %radius of overlap circle

A=3.14159*a^2