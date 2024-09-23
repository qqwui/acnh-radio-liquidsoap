#!/usr/bin/liquidsoap

enable_replaygain_metadata()

icecast_host = "localhost"
icecast_port = 8000
icecast_password = "hackme"

hourly_mount = "hourly.ogg"
hourly_name = "AC Hourly Music"
hourly_desc = "Animal Crossing Hourly music, day tracks during the day and night tracks at night"

day_normal = playlist("/icecast/hourly/day.pls")
night_normal = playlist("/icecast/hourly/night.pls")
day_special = playlist("/icecast/hourly/day_special.pls", mode="random")
night_special = playlist("/icecast/hourly/night_special.pls", mode="random")

day = random(weights=[1, 20], [day_special, day_normal])
night = random(weights=[1, 20], [night_special, night_normal])

radio = replaygain(switch([({7h-18h}, day), ({19h-6h}, night)]))


output.icecast(
    %ffmpeg(format="ogg", %audio(codec="libvorbis", samplerate=48000, b="112K")),
    host=icecast_host, port=icecast_port, password=icecast_password, mount=hourly_mount,
    name=hourly_name, description=hourly_desc,
    mksafe(radio)
)
