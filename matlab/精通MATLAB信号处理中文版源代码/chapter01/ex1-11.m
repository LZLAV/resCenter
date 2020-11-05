try
    picture=imread('football.bmp','bmp');
    filename='football.bmp';
catch
    picture=imread('football.jpg','jpg');
    filename='football.jpg';
end
filename
