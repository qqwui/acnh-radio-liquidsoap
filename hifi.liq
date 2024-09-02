#!/usr/bin/liquidsoap --quiet

icecast_host = "localhost"
icecast_port = 8000
icecast_password = "hackme"

hifi_playlist = playlist("/icecast/hifi/playlist.pls")
hifi_mount = "hifi.ogg"
hifi_name = "ACNH Hifi Radio"
hifi_desc = "K.K. Tracks in high quality"

output.icecast(
    %ffmpeg(format="ogg", %audio(codec="libvorbis")),
    host=icecast_host, port=icecast_port, password=icecast_password, mount=hifi_mount,
    name=hifi_name, description=hifi_desc,
    mksafe(hifi_playlist)
)
