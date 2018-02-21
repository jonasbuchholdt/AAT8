function [ImpulseResponseVector] = Soundcard(numAverages,minIRDuration,OutChan,InChan,fs,Scale)
 


    recorderNumChannels = length(InChan);
 
    aPR = audioPlayerRecorder('SampleRate',fs,'RecorderChannelMapping',InChan,'PlayerChannelMapping',OutChan);
 
 
    for i=1:1024:length(inputChannel)
 
        if (i+1024)>length(inputChannel)
            sequence = [inputChannel(i:end,:) ; zeros(1024-length(inputChannel(i:end,:)),length(OutChan))];
            tmp=2;
        else
            sequence = inputChannel(i:i+1023,:);
            tmp=2;
        end
 
 
 
        [newsineRec,~,~] = aPR(sequence);
        
        sineRec=vertcat(sineRec,newsineRec);
    end
 
    outputChannels=sineRec;
 
 
end