function ChannelOutVec = ChannelTXRXAudio(config,ChannelInVec)

% normalize
disp('Using Audio Channel');
normalizationfact = 2*max(abs(ChannelInVec));
audiooutvecaudio = ChannelInVec(:)/normalizationfact;
audiooutvecaudio = [audiooutvecaudio(:),0*audiooutvecaudio(:)]; % zero the right channel
% play the audio

disp('Playing the audio');
sound(audiooutvecaudio,config.Fs);

% record
% open the microphone - the "receiver"
recObj = audiorecorder(config.Fs,config.nBitsAudio,config.nChannels,config.ID);
disp(['Start recording for ',num2str(config.audiorecordinglength),' seconds']);
recordblocking(recObj,config.audiorecordinglength);
disp('End of recording.');
audioinmat = getaudiodata(recObj);
ChannelOutVec = audioinmat(:,1);
