clear all;
lshaar = liftwave('haar');
els = {'p',[-0.25 0.25],0};
lsnew = addlift(lshaar,els);
x = reshape(1:16,4,4);
[cA,cH,cV,cD] = lwt2(x,lsnew)
lshaarInt = liftwave('haar','int2int');
lsnewInt = addlift(lshaarInt,els);
[cAint,cHint,cVint,cDint] = lwt2(x,lsnewInt)
