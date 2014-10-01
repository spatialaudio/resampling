include "stdio.h"

void *zoh(float sp, void *audio_signal){
	int i;
	void *resampled_audio_signal;
	if (sp == 0) {
		return *audio_signal;
	}
	else if (sp < 0){
		printf("Error: The Sample Position is negative. Signal has not been resampled");
		return *audio_signal;
	else if{
		for (i=0; i++; i<=sizeof(audio_signal)) {
			resampled_audio_signal[i] = audio_signal[int(i+sp)];
		}
		return resamled_audio_signal;		
}

void main(int argc, char **argv){
	
	int sample1[] = {1,3,5,1,2,8,4,5,1,11}
	int sample2[] = {2,22,12,13,15,5,7,8,4}
	float sample_position[0.5,1.5,2.5,3.75]
	
	return 0;
}
