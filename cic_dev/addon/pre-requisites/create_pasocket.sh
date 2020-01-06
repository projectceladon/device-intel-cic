#!/usr/bin/env bash
# author: sundar.gnanasekaran@intel.com

audio_ipc="$AIC_WORK_DIR/ipc/config/audio"


if [[ ! -f "$audio_ipc/cic_pulseaudio_out.socket" && ! -f $audio_ipc/cic_pulseaudio_in.socket ]]; then
	rm -rf $audio_ipc/cic_pulseaudio_out.socket $audio_ipc/cic_pulseaudio_in.socket
fi

pactl load-module module-simple-protocol-unix rate=48000 format=s16le channels=2 sink=@DEFAULT_SINK@ playback=true socket=$audio_ipc/cic_pulseaudio_out.socket 
pactl load-module module-simple-protocol-unix rate=48000 format=s16le channels=2 source=@DEFAULT_SOURCE@ record=true socket=$audio_ipc/cic_pulseaudio_in.socket
