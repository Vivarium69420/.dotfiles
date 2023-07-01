# Resources

- Dotfiles:
  https://github.com/anandpiyer/.dotfiles/blob/master/.dotfiles/README.md
- Orignal: https://github.com/PROxZIMA/.dotfiles.git

# Dependencies

- Important:

* Dynamic tiling Wayland compositor:
  https://wiki.hyprland.org/Getting-Started/Installation/
* Intel Audio:

```
yay -Su sof-firmware pipewire pulseaudio
```

- Keyboard Language:

```
yay -Su fcitx5 fcitx5-unikey fcitx5-config-qt fcitx5-configtool
```

- System:

```
sudo pacman -Su base-devl filesystem devtools
```

- Optional

* Apps:

```
yay -S libreoffice-fresh obsidian obs-studio edge onedrive  foxitreader microsoft-edge-dev-bin swaylock ntfs-3g google-chrome-dev discord neovim
```

- Tor Broswer:
  https://www.youtube.com/watch?v=KTfWu0GFKTc&t=645s&ab_channel=Stephen%27sTechTalks

```
yay -S tor-browser tor nyx torsocks wget gnu-netcat socat torbrowser-launcher
```

# GTK theme, icon, cursor

- GTK Theme :: Tokyonight-Dark-BL-LB:

```
cd ~/Downloads
git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git
cd Tokyo-Night-GTK-Theme/
sudo cp -r themes/Tokyonight-Dark-BL-LB /usr/share/themes/
```

- Icons:: Tokyonight-Moon:

```
cd ~/Downloads
git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git
cd Tokyo-Night-GTK-Theme/
sudo cp -r icons/Tokyonight-Moon /usr/share/icons/
```

- Cursors :: Sweet-cursors:

```
cd ~/Downloads
git clone https://github.com/EliverLara/Sweet.git -b nova
cd Sweet/
sudo cp -r kde/cursors/Sweet-cursors /usr/share/icons/
```

# Extra

- libinput-gestures-setup start might fail, if so add, and reboot:

```sudo gpasswd -a $USER input
newgrp input
```
