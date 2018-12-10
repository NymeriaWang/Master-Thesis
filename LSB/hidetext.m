function[voinew]=hidetext(voice,text)
% red=bitand(redc,248);
%green=bitand(greenc,248);
vomiddle=bitand(voice,254);

text=bitand(text,1);
voinew=bitor(vomiddle,text);

return