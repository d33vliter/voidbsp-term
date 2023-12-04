import os
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile import hook
from libqtile.utils import guess_terminal
from pywayland import lib
import funcion as f

mod = "mod4"
terminal = guess_terminal()

keys = [

    #lanzar terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    #reload configs
    Key([mod, "mod1"], "r", lazy.reload_config(), desc="Reload the config"),

    #cerrar sesion
    Key([mod, "mod1"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    #abrir rofi
    Key([mod], "d", lazy.spawn('rofi -show drun -display-drun ""'), desc="Abrir rofi en forma de drun"),


    #minimizar, maximizar ventana
    Key([mod], "g", lazy.window.toggle_minimize(), desc="Toggle minimization on focused window"),
    #cambiar a ventana flotante
    Key([mod], "s", lazy.window.toggle_floating(), lazy.window.center(), desc='Toggle floating'),
    #ventana en pantalla completa
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc='Toggle fullscreen'),
    #split horizontal/vertical
    Key([mod], "h", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    # cambiar de tiling a monocle :v
    Key([mod], "m", lazy.next_layout(), desc="Toggle between layouts"),
    # cerrar ventana
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

    #enfocar ventanas arriba abajo izquierda derecha
    Key([mod], "left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.group.next_window(), f.float_cycle_f(), desc="Move window focus to other window"),

    #moverse con la ventana a otro workspace
    Key([mod, "shift"], "left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up(), desc="Move window up"),
    

]


groups = [Group(i) for i in "1234"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Bsp(     border_focus=["#ffffff"],
                        border_normal=["#000000"],
                        border_width=2,
                        lower_right=True,
                        fair=False),
    layout.Max(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=4,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                #widget.CurrentLayout(),
                widget.GroupBox(foreground='ffffff',borderwidth=2,highlight_method='line',
                    this_current_screen_border='ffffff',highlight_color=['000000', '000000'],),
                #widget.Prompt(),
                widget.WindowName(),
                #widget.Chord(
                #    chords_colors={
                #        "launch": ("#ff0000", "#ffffff"),
                #    },
                #    name_transform=lambda name: name.upper(),
                #),
                #widget.TextBox("default config", name="default"),
                #widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(icon_size=14),
                widget.Clock(format='%d/%m/%y %H:%M',fontsize=11,),
                #widget.QuickExit(),
            ],
            20,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
#mouse = [
#    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
#    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
#    Click([mod], "Button2", lazy.window.bring_to_front()),
#]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(border_focus=["#ffffff"],
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "Qtile"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])
