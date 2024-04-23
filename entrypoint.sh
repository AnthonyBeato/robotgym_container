#!/bin/bash
set -e

# Configurar ROS
source /opt/ros/iron/setup.bash

# Configuraciones de entorno necesarias para QT y otras aplicaciones
export DISPLAY=:19
export QT_QPA_PLATFORM=offscreen
export AUDIODEV=null
export ALSA_CONFIG_PATH=/dev/null
export XDG_RUNTIME_DIR=/tmp
export QT_DEBUG_PLUGINS=1

# Ir al directorio de trabajo y construir el proyecto
# cd /home/ubuntu/simulation_ws
colcon build --symlink-install
# source install/setup.bash

# Iniciar aplicaciones con VirtualGL
vglrun gazebo &
vglrun rviz2 &

# Mantener el contenedor en ejecución si no se pasan comandos adicionales
exec "$@"
