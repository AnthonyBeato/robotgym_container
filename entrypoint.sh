#!/bin/bash
set -e

# Configurar ROS
source /opt/ros/iron/setup.bash

# Ir al directorio de trabajo y construir el proyecto
# cd /home/ubuntu/simulation_ws
# colcon build --symlink-install
# source install/setup.bash

# (Aquí irían comandos adicionales para lanzar tu simulación)
vglrun gazebo &
vglrun rviz2 &

export QT_QPA_PLATFORM=vnc
export AUDIODEV=null
export ALSA_CONFIG_PATH=/dev/null



# Mantener el contenedor en ejecución si no se pasan comandos adicionales
exec "$@"