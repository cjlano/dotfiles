import os
from i3pystatus import Status
from i3pystatus.updates import pacman
#from . import Status
status = Status(standalone=True)

# There's a clock, too
status.register("clock",
    format = "%d/%m/%Y %H:%M")

status.register("load",
    format="{avg1}")

thermaldir = '/sys/class/thermal/'
try:
    thermal = next(t for t in os.listdir(thermaldir) if 'x86_pkg_temp' in \
                   next(open(thermaldir+t+'/type')))
except StopIteration:
    thermal = 'thermal_zone0'

status.register("temp",
    format="{temp:.0f}°C",
    file=thermaldir + thermal + '/temp'
    )

# the battery status checker module
status.register("battery",
    format = "{status}{percentage:.0f}% {remaining}",
    alert=True,
    alert_percentage=15,
    status={
        "DIS": "↓",
        "CHR": "↑",
        "FULL": "=",
        },
    )


netdir = '/sys/class/net/'
wireless = [iface for iface in os.listdir(netdir) if os.path.isdir(netdir + iface + '/wireless')]
wired = [iface for iface in os.listdir(netdir) if iface not in wireless + ['lo']]

for iface in wired:
    status.register("network",
        interface=iface,
        format_up = iface + ": {v4}",
        format_down = iface + ": down")

for iface in wireless:
    status.register("network",
        interface=iface,
        dynamic_color = False,
        format_up = iface + ": ({quality:.0f}% at {essid}) {v4}",
        format_down = iface + ": down")


status.register("disk",
    path="/",
    display_limit = 100,
    critical_limit = 50,
    format = "/: {avail:.0f}G {percentage_used:.0f}%")

status.register("backlight",
        format="\u263c{percentage:.0f}%", #\u263c: white sun with rays
    backlight="intel_backlight")

# Note: requires pyalsaaudio (AUR)
#status.register("alsa",
#        format="\u266A{volume}",) #\u266A:  Character '♪' 'EIGHTH NOTE'

# Shows pulseaudio default sink volume
status.register("pulseaudio",
            format="♪{volume}",)

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
# status.register("mpd",
#         format="{artist}{status}{title}",
#         status={
#             "pause": "▷",
#             "play": "▶",
#             "stop": "◾",
#             },)

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

status.register("pomodoro", sound='')


status.register("updates",
                format = "Updates: {count}",
                format_no_updates = "No updates",
                backends = [pacman.Pacman()])

# start the handler
status.run()

