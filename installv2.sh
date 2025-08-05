#!/usr/bin/bash

# VoidBSP Installer v2.0 by d33vliter
# Mejorado con sugerencias de la comunidad

# --- CONFIGURACIÓN Y PREPARACIÓN ---

# Salir inmediatamente si un comando falla
set -eo pipefail

# Definir colores para una salida más clara
C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m' # Sin color

# --- FUNCIONES AUXILIARES ---

# Función para imprimir mensajes informativos
info() {
    echo -e "${C_BLUE}[INFO]${C_NC} $1"
}

# Función para imprimir mensajes de éxito
success() {
    echo -e "${C_GREEN}[SUCCESS]${C_NC} $1"
}

# Función para imprimir advertencias
warning() {
    echo -e "${C_YELLOW}[WARNING]${C_NC} $1"
}

# --- VERIFICACIÓN DE PERMISOS Y USUARIO ---

# Verificar que el script se ejecuta como root
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${C_RED}[ERROR]${C_NC} Por favor, ejecuta este script como root (ej: sudo ./install.sh)"
    exit 1
fi

# Detectar el usuario real que invocó sudo
REAL_USER="${SUDO_USER:-$(whoami)}"
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

if [[ -z "$USER_HOME" ]]; then
    echo -e "${C_RED}[ERROR]${C_NC} No se pudo determinar el directorio home del usuario '$REAL_USER'."
    exit 1
fi

# --- DEFINICIÓN DE PAQUETES ---

# Paquetes esenciales y del sistema Xorg
PKGS_ESSENTIALS=(
    at-spi2-core p7zip xdg-user-dirs xorg-minimal xorg-fonts
    xsetroot gvfs gnome-keyring lxsession dash git
)

# Entorno BSPWM y herramientas clave
PKGS_BSPWM_TOOLS=(
    bspwm sxhkd polybar dmenu rofi scrot xdo setxkbmap numlockx
    dbus sakura elogind fzf feh bat parcellite dragon pcmanfm nwg-look
)

# Programas adicionales y temas visuales
PKGS_APPS_THEMES=(
    pulsemixer pipewire wireplumber rtkit pfetch nerd-fonts noto-fonts-emoji
    mpv arandr neovim xarchiver nitrogen firefox gnome-themes-extra-gtk picom
)

# Librerías de 32 bits (para juegos/Wine)
PKGS_32BIT=(
    mesa-dri-32bit glu-32bit libgcc-32bit libstdc++-32bit libdrm-32bit
    libglvnd-32bit freetype-32bit vulkan-loader-32bit mesa-vulkan-radeon-32bit
)

# --- FASES DE LA INSTALACIÓN ---

main() {
    clear
    display_header
    update_system
    install_packages
    enable_multilib
    install_32bit_libs
    configure_system
    deploy_dotfiles
    final_message
}

display_header() {
    echo -e "${C_BLUE}|---------------------|"
    echo -e "| VoidBSP Installer   |"
    echo -e "|---------------------|${C_NC}"
    echo
    info "Iniciando la instalación para el usuario: ${C_YELLOW}$REAL_USER${C_NC}"
    info "Directorio Home: ${C_YELLOW}$USER_HOME${C_NC}"
    sleep 3
}

update_system() {
    info "Actualizando repositorios y sistema base..."
    xbps-install -Syu
    success "Sistema actualizado."
}

install_packages() {
    info "Instalando paquetes..."
    # Unimos todas las listas de paquetes en una sola llamada
    xbps-install -y "${PKGS_ESSENTIALS[@]}" "${PKGS_BSPWM_TOOLS[@]}" "${PKGS_APPS_THEMES[@]}"
    success "Paquetes principales instalados."
}

enable_multilib() {
    info "Activando repositorios non-free y multilib..."
    xbps-install -y void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
    info "Sincronizando con los nuevos repositorios..."
    xbps-install -Sy
    success "Repositorios adicionales activados."
}

install_32bit_libs() {
    echo
    read -rp "$(echo -e ${C_YELLOW}"¿Deseas instalar las librerías de 32-bit para juegos/Wine? (s/N): "${C_NC})" response
    if [[ "$response" =~ ^([sS][iI]?|[yY])$ ]]; then
        info "Instalando librerías de 32-bit..."
        xbps-install -y "${PKGS_32BIT[@]}"
        success "Librerías de 32-bit instaladas."
    else
        info "Omitiendo instalación de librerías de 32-bit."
    fi
}

configure_system() {
    info "Configurando el sistema y activando servicios..."

    # 1. Fix de fuentes
    ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
    xbps-reconfigure -f fontconfig

    # 2. Activar servicios runit
    ln -sf /etc/sv/dbus /var/service/
    ln -sf /etc/sv/elogind /var/service/

    # 3. Configuración de Pipewire
    mkdir -p /etc/pipewire/pipewire.conf.d
    ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

    # 4. Wallpaper predeterminado
    install -d /usr/share/wall
    # Asume que el wallpaper está en una carpeta relativa al script
    if [ -f "default_wallpaper/default.jpg" ]; then
        cp -f "default_wallpaper/default.jpg" "/usr/share/wall/"
    else
        warning "No se encontró el wallpaper predeterminado. Omitiendo."
    fi

    success "Configuración del sistema completada."
}

deploy_dotfiles() {
    info "Desplegando archivos de configuración (dotfiles) para $REAL_USER..."

    # Ejecutar todas las operaciones del home del usuario COMO el usuario
    sudo -u "$REAL_USER" bash <<EOF
    
    # Crear directorios base
    mkdir -p "$USER_HOME"/.config "$USER_HOME"/.local/bin "$USER_HOME"/captures

    # Actualizar carpetas de usuario
    xdg-user-dirs-update

    # Crear ~/.xinitrc
    if [ -f "$USER_HOME/.xinitrc" ]; then
        mv "$USER_HOME/.xinitrc" "$USER_HOME/.xinitrc.bak"
    fi
    cat << 'EOM' > "$USER_HOME/.xinitrc"
#!/bin/sh

# Autostart applications
if [ -d "\$HOME/.local/bin" ]; then
    PATH="\$HOME/.local/bin:\$PATH"
fi

pipewire &
# pipewire-pulse & # Descomentar si es necesario
# wireplumber & # Descomentar si es necesario

# Iniciar la sesión de bspwm
exec dbus-run-session bspwm
EOM

    # Copiar configuraciones (asume que el script se ejecuta desde la raíz del repo)
    # El flag -n previene sobreescribir archivos existentes
    if [ -d ".config" ]; then
        cp -rn .config/* "$USER_HOME/.config/"
    fi
    if [ -d "bash/_scripts" ]; then
        cp -n bash/_scripts/* "$USER_HOME/.local/bin/"
    fi
    if [ -f "bash/.bashrc" ]; then
        cp -n bash/.bashrc "$USER_HOME/.bashrc"
    fi
    if [ -f "bash/.bash_profile" ]; then
        cp -n bash/.bash_profile "$USER_HOME/.bash_profile"
    fi
EOF
    success "Dotfiles desplegados."
}

final_message() {
    echo
    success "¡Instalación de VoidBSP completada!"
    warning "Es necesario reiniciar para aplicar todos los cambios."
    read -n 1 -s -r -p "Presione cualquier tecla para reiniciar ahora..."
    echo
    reboot
}

# --- EJECUCIÓN DEL SCRIPT ---
main "$@"
