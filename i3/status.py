import locale
from i3pystatus import Status
#from . import Status
status = Status(standalone=True)

# French locale
locale.setlocale(locale.LC_ALL,('fr_FR', 'UTF-8'))

# There's a clock, too
status.register("clock",
    format = "%A %d/%m/%Y %H:%M")

status.register("load",
        format="CPU: {avg1}")
# status.register("mem_bar")
status.register("mem", format="RAM: {percent_used_mem}%")
status.register("temp",
    format="{temp:.0f}°C")

# the battery status checker module
#status.register("battery",
#    format = "{status}{percentage:.0f}% {remaining}",
#    alert=False,
#    alert_percentage=25,
#    status={
#        "DIS": "↓",
#        "CHR": "↑",
#        "FULL": "=",
#        },
#    )

#status.register("wireless",
#    interface="wlo1",
#    format_up = "W: ({quality:.0f}% at {essid}) {v4}",
#    format_down = "W: down")

status.register("network",
    interface="eth1",
    format_up = "E: {v4}",
    format_down = "E: down")

status.register("disk",
    path="/",
    format = "/: {avail:.0f}G {percentage_used:.0f}%")

#status.register("backlight",
#    format="\u263c{brightness}%", #\u263c: white sun with rays
#    backlight="psb-bl")

# Note: requires pyalsaaudio (AUR)
#status.register("alsa",
#        format="\u266A{volume}",) #\u266A:  Character '♪' 'EIGHTH NOTE'

# Shows pulseaudio default sink volume
status.register("pulseaudio",
            format="♪{volume}",)

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
#status.register("mpd",
#        format="{artist}{status}{title}",
#        status={
#            "pause": "▷",
#            "play": "▶",
#            "stop": "◾",
#            },)

# You can let i3pystatus check for new mail using the mail module
# It can check multiple sources with multiple backends

# The IMAP backend
#from .mail.imap import IMAP
#imap_servers = {
#    "color": "#ff0000",
#    "servers": [
#        {
#            "host": "",
#            "port": "",
#            "ssl" : True,
#            "username": "",
#            "password": "",
#            "pause": 20
#        }
#    ]
#}
#imap = IMAP(imap_servers)
#
#status.register("mail",
#    backends=[ imap ])


status.register("shell", command="$HOME/bin/wirgrid_date.py", interval=1)

# start the handler
status.run()

