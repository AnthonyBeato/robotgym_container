FROM osrf/ros:iron-desktop-full

# Instalando nano y vim 
RUN apt-get update \
    && apt-get install -y \
    nano \
    vim \ 
    wget \
    && rm -rf /var/lib/apt/lists/*


# Configurando usuario no-root 
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Creando el usuario
RUN groupadd --gid $USER_UID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Activar sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias para Gazebo y otros paquetes de ROS
RUN sudo apt-get update && sudo apt-get install -y \
    ros-iron-gazebo-ros-pkgs \
    ros-iron-xacro \
    ros-iron-joint-state-publisher-gui \
 && sudo rm -rf /var/lib/apt/lists/*


# Instalar dependencias comunes y necesarias para VirtualGL
RUN apt-get update && apt-get install -y \
    libglu1-mesa \
    mesa-utils \
    libxv1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalación de VirtualGL
RUN apt-get update && apt-get install -y wget \
    && wget -q -O virtualgl.deb https://sourceforge.net/projects/virtualgl/files/3.1/virtualgl_3.1_amd64.deb/download \
    && dpkg -i virtualgl.deb || apt-get install -fy \
    && rm virtualgl.deb

# Configurar VirtualGL
RUN if [ -f /opt/VirtualGL/bin/vglserver_config ]; then \
        /opt/VirtualGL/bin/vglserver_config -config +s +f -t; \
    else \
        echo "vglserver_config not found, check VirtualGL installation."; \
        exit 1; \
    fi

RUN apt-get update && apt-get install -y \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0 \
    libqt5gui5 \
    libqt5widgets5 \
    libqt5x11extras5 \
    qt5-gtk-platformtheme \
    libqt5dbus5 \
    qttools5-dev-tools \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*



# Copiar tu espacio de trabajo de simulación al contenedor
# Asegúrate de que la estructura de directorios en tu máquina local refleje lo que espera el contenedor
COPY ./simulation_ws /home/${USERNAME}/simulation_ws

# Cambiar el propietario del espacio de trabajo copiado al usuario no-root
RUN sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/simulation_ws

COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc

# Configuración de permisos y entorno
RUN chmod +x /entrypoint.sh \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc

# Establecer el entorno de trabajo del usuario
USER $USERNAME
WORKDIR /home/$USERNAME

ENTRYPOINT ["/entrypoint.sh" ]
CMD ["bash"]