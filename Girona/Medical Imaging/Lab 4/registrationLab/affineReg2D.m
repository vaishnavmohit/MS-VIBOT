function [ Iregistered, M] = affineReg2D( Imoving, Ifixed, multi_res)
%Example of 2D affine registration
%   Robert Mart�  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente 

% clean
    clear; close all; clc;

    % Read two imges 
    Imoving=im2double(rgb2gray(imread('brain1.png'))); 
    Ifixed=im2double(rgb2gray(imread('brain4.png')));

    % Smooth both images for faster registration
    ISmoving_o=imfilter(Imoving,fspecial('gaussian'));
    ISfixed_o=imfilter(Ifixed,fspecial('gaussian'));    

    mtype = 'cc'; % metric type: s: ssd m: mutual information e: entropy, cc: cross correlation 
    ttype = 'a'; % rigid registration, options: r: rigid, a: affine
    multi_res = 3;
    
    switch ttype
        case 'r' %rigid transformation
            % Parameter scaling of the Translation and Rotation
            scale=[1.0 1.0 0.1];
            % Set initial affine parameters
            x=[0.0 0.0 0.0];
        case 'a' %affine transformation
            % Parameter scaling of the Translation and Rotation and shear
            % factors
            scale=[1.0 1.0 0.1 0.1 0.1 0.1 0.1];
            % Set initial affine parameters
            x=[0.0 0.0 0.0 1.0 1.0 1.0 1.0];
        otherwise
            error('Unknown metric type');
    end

    for i = multi_res:-1:1
        
        ISmoving = imresize(ISmoving_o, 1/(2^(i-1)));
        ISfixed = imresize(ISfixed_o, 1/(2^(i-1)));


        % two in scale and x changes when either 4 parameters are used and when 6 parameters are
        % used. but when we use 7 parameters we got a correct image

        x=x./scale;

        %[x]=fminunc(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x)));
        [x]=fminsearch(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000,'Algorithm','interior-point', 'TolFun', 1.000000e-20,'TolX',1.000000e-20, 'MaxFunEvals', 1000*length(x)));

        % Scale the translation, resize and rotation parameters to the real values
        x=x.*scale;
        
        switch ttype
            case 'r' %rigid transformation
                % Make the affine transformation matrix
                M=[ cos(x(3)) sin(x(3)) x(1);
                   -sin(x(3)) cos(x(3)) x(2);
                   0 0 1];
            case 'a' %affine transformation
                M=[ x(4)*cos(x(3)) x(5)*sin(x(3)) x(1);
                   -x(6)*sin(x(3)) x(7)*cos(x(3)) x(2);
                   0 0 1];
            otherwise
                error('Unknown metric type');
        end


        % Transform the image 
        Icor=affine_transform_2d_double(double(ISmoving),double(M),0); % 3 stands for cubic interpolation

        % Show the registration results
        figure,
            subplot(2,2,1), imshow(Ifixed);
            subplot(2,2,2), imshow(Imoving);
            subplot(2,2,3), imshow(Icor);
            subplot(2,2,4), imshow(abs(ISfixed-Icor));
            
        x(1)= x(1)*2;
        x(2)= x(2)*2;
    end
    
    
end

