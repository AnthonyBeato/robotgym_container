FROM osrf/ros:iron-desktop-full

# Instalando nano y vim 
RUN apt-get update \
    && apt-get install -y \
    nano \
    vim \ 
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

# Copiar tu espacio de trabajo de simulación al contenedor
# Asegúrate de que la estructura de directorios en tu máquina local refleje lo que espera el contenedor
COPY ./simulation_ws /home/${USERNAME}/simulation_ws

# Cambiar el propietario del espacio de trabajo copiado al usuario no-root
RUN sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/simulation_ws

# (Otras instrucciones de configuración que puedas necesitar)


COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]

CMD ["bash"]