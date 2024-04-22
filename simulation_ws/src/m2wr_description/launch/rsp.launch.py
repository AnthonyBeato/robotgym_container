from launch import LaunchDescription
from launch_ros.actions import Node
import xacro
import os
from ament_index_python.packages import get_package_share_directory

#Robot State Publisher Launch File
def generate_launch_description():

    # Especificar el nombre del paquete y el path al xacro file
    pkg_name = 'm2wr_description'
    file_subpath = '/thesis_project/simulation_ws/src/m2wr_description/urdf/m2wr.urdf.xacro'

    # Usar xacro para procesar el archivo
    xacro_file = os.path.join(get_package_share_directory(pkg_name), file_subpath)
    robot_description_raw = xacro.process_file(xacro_file).toxml()

    # Configrar el nodo
    node_robot_state_publisher = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        output='screen',
        parameters=[{'robot_description': robot_description_raw}] 
    )


    #Correr el nodo
    return LaunchDescription([
        node_robot_state_publisher
    ])