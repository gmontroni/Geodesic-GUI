function [v, f] = make_box(p1, p2)
% MAKE_BOX Summary of this function goes here
% Detailed explanation goes here

v = [...
  p1(1), p1(2), p1(3); ...
  p2(1), p1(2), p1(3); ...
  p2(1), p2(2), p1(3); ...
  p1(1), p2(2), p1(3); ...
  p1(1), p1(2), p2(3); ...
  p2(1), p1(2), p2(3); ...
  p2(1), p2(2), p2(3); ...
  p1(1), p2(2), p2(3)];
f = [...
  1, 5, 8, 4; ...
  2, 6, 7, 3; ...
  1, 5, 6, 2; ...
  4, 3, 7, 8; ...
  1, 2, 3, 4; ...
  5, 8, 7, 6];
  