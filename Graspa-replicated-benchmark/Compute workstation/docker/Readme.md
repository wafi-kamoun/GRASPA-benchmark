# Grasping Benchmarks Replication

This repository contains the replication workflow for the [hsp-panda/grasping-benchmarks-panda](https://github.com/hsp-panda/grasping-benchmarks-panda) framework. This guide provides step-by-step instructions to run the Docker-based benchmark environments for **Dex-Net**, **GPD**, and **6D-GraspNet** and execute grasp commands via ROS.

## Prerequisites

* **Docker**: Installed and configured on your machine.
* **ROS**: A working ROS installation.
* The base repository cloned to `~/Documents/grasping-benchmarks-panda`.

## Network Configuration Setup

For each environment, you must configure your ROS network variables so the container and host can communicate. The commands below use the following custom aliases and IPs (update the IP addresses to match your specific setup if migrating to a new network):

* **ROS Master IP:** `132.180.194.17`
* **Local ROS IP:** `132.180.194.115`

---

## 1. Running the Dex-Net Benchmark

Open a terminal and navigate to the docker directory to spin up the Dex-Net container:

```bash
cd ~/Documents/grasping-benchmarks-panda/docker
./run.sh wafi dexnet-container wafi/benchmark_dexnet:latest
```

Configure your ROS IPs and launch the benchmark environment:

```bash
rossetmaster 132.180.194.17
rossetip 132.180.194.115
roslaunch grasping_benchmarks_ros grasp_planning_benchmark.launch realsense:=false dexnet:=true
```

Open a new terminal, configure the network again, and trigger the grasp command:

```bash
rossetmaster 132.180.194.17
rossetip 132.180.194.115
rosservice call /dexnet_bench/user_cmd "cmd: {data: 'grasp'}"
```

---

## 2. Running the GPD Benchmark

Open a terminal and navigate to the docker directory to spin up the GPD container:

```bash
cd ~/Documents/grasping-benchmarks-panda/docker
./run.sh wafi gpd-container wafi/benchmark_gpd:latest
```

Configure your ROS IPs and launch the benchmark environment:

```bash
rossetmaster 132.180.194.17
rossetip 132.180.194.115
roslaunch grasping_benchmarks_ros grasp_planning_benchmark.launch realsense:=false gpd:=true
```

Open a new terminal, configure the network, and trigger the grasp command:

```bash
rossetmaster 132.180.194.17
rossetip 132.180.194.115
rosservice call /gpd_bench/user_cmd "cmd: {data: 'grasp'}"
```

---

## 3. Running the 6D-GraspNet Benchmark

Open a terminal and navigate to the docker directory to spin up the 6D-GraspNet container:

```bash
cd ~/Documents/grasping-benchmarks-panda/docker
./run.sh wafi 6dgraspnet-container wafi/benchmark_6dgraspnet:latest
```

Configure your ROS IPs and launch the benchmark environment:

```bash
rossetmaster 132.180.194.17
rossetip 132.180.194.115
roslaunch grasping_benchmarks_ros grasp_planning_benchmark.launch realsense:=false graspnet:=true
```

Open a new terminal, configure the network, and trigger the grasp command:

```bash
rossetmaster 132.180.194.17
rossetip 132.180.194.115
rosservice call /graspnet_bench/user_cmd "cmd: {data: 'grasp'}"
```

---

## Acknowledgements

This replication runs Docker containers and algorithms originally provided by [hsp-panda/grasping-benchmarks-panda](https://github.com/hsp-panda/grasping-benchmarks-panda).