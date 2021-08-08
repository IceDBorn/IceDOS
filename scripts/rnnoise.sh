# Enable RNNoise from the given path

python3 dev/rnnoise-pulseaudio-control/src/rnnoise.py enable

# Change default device to given index

pacmd set-default-source 2

# Wait to battle race condition

sleep 1

# Set capture volume to given value

amixer -D pulse sset Capture 50%