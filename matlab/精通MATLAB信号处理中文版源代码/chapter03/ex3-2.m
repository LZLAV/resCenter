clear all;close all;clc;
B=poly([-0.4 -0.4]);
A=poly([-0.8 -0.8 0.5 0.5 -0.1]);
[R P K]=residuez(B,A);
R=R'
P=P'
K
