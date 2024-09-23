#!/usr/bin/liquidsoap

icecast_host = "localhost"
icecast_port = 8000
icecast_password = "hackme"

acnh_mount = "acnh-radio.ogg"
acnh_name = "ACNH Radio"
acnh_desc = "Animal Crossing New Horizons radio simulation complete with \"ads\" and \"commentary\""

acnh_ads       = playlist.files("/icecast/acnh_radio/ads.pls")
acnh_kk        = playlist.files("/icecast/acnh_radio/dj_kk.pls")
acnh_kk_emotes = playlist.files("/icecast/acnh_radio/dj_kk_emotes.pls")
acnh_jingles   = playlist.files("/icecast/acnh_radio/jingles_normal.pls")
acnh_music     = playlist.files("/icecast/acnh_radio/music.pls")

#print(acnh_ads)
#print(acnh_kk)
#print(acnh_kk_emotes)
#print(acnh_jingles)

def acnh_source()
  songs_pl = ref([])
  break_time = ref(true)
  
  def next()
    if list.is_empty(songs_pl()) then
      #print("list empty")
      if break_time() then 
        songs_pl := list.add(list.pick(acnh_kk), songs_pl())
        songs_pl := list.add(list.pick(acnh_ads), songs_pl())
        songs_pl := list.add(list.pick(acnh_jingles), songs_pl())
        songs_pl := list.add(list.pick(acnh_kk_emotes), songs_pl())
      else
        for _ = 1 to random.int(min=3,max=6) do
          songs_pl := list.add(list.pick(acnh_music), songs_pl())
        end
      end
      break_time := not break_time()
      #print(songs_pl())
    end
    
    song = list.hd(songs_pl())
    #print(song)
    songs_pl := list.tl(songs_pl())
    request.create(song)
    
  end
  request.dynamic(next)
end

output.icecast(
    %ffmpeg(format="ogg", %audio(codec="libvorbis")),
    host=icecast_host, port=icecast_port, password=icecast_password, mount=acnh_mount,
    name=acnh_name, description=acnh_desc,
    mksafe(acnh_source())
)
