#!/bin/bash
set -e

# Configurar ROS
source /opt/ros/iron/setup.bash

# Ir al directorio de trabajo y construir el proyecto
cd /home/${USERNAME}/simulation_ws
colcon build --symlink-install
source install/setup.bash

# (Aquí irían comandos adicionales para lanzar tu simulación)
gazebo &
rviz2 &

# Mantener el contenedor en ejecución si no se pasan comandos adicionales
exec "$@"