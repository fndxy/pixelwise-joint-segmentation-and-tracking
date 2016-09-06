function [nf,nb,H] = caculate_n(phi,ind_x,ind_y,epislon)
H= Heaviside(phi,epislon,ind_x,ind_y);
nf = sum(H);
nb = sum(1-H);
