Para no tener tearing en gpu amd xd

sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 20-amdgpu.conf /etc/X11/xorg.conf.d/
