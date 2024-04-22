from launch import LaunchDescription
from launch_ros.actions import Node
import xacro
import os
from ament_index_python.packages import get_package_share_directory
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.actions import IncludeLaunchDescription


#Robot State Publisher Simulation Launch File
def generate_launch_description():

    # Especificar el nombre del paquete y el path al xacro file
    pkg_name = 'ti_rlsk_description'
    file_subpath = '/thesis_project/simulation_ws/src/ti_rlsk_description/urdf/ti_rlsk_max_robot.urdf.xacro'

    # Usar xacro para procesar el archivo
    xacro_file = os.path.join(get_package_share_directory(pkg_name), file_subpath)
    robot_description_raw = xacro.process_file(xacro_file).toxml()

    # Configrar el nodo
    node_robot_state_publisher = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        output='screen',
        parameters=[{'robot_description': robot_description_raw,
                     'use_sim_time': True}] 
    )

    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('gazebo_ros'), 'launch'), '/gazebo.launch.py']),
    )

    spawn_entity = Node(package='gazebo_ros', executable='spawn_entity.py', arguments=['-topic', 'robot_description', '-entity', 'ti_rlsk_max'], output='screen')

    #Correr el nodo
    return LaunchDescription([
        gazebo,
        node_robot_state_publisher,
        spawn_entity
    ])