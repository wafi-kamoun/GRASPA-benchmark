# Graspa Replicated Benchmark

This repository contains the replication workflow for the experimental setup described in **"GRASPA-fying the Panda: Easily Deployable, Fully Reproducible Benchmarking of Grasp Planning Algorithms"**. It provides a fully Dockerized, dual-workstation framework to benchmark robotic grasp planning algorithms on a Franka Emika Panda arm using the GRASPA protocol.

The pipeline supports benchmarking for the following state-of-the-art algorithms :
* **Dex-Net** 
* **GPD (Grasp Pose Detection)** 
* **6DoF-GraspNet** 

## Hardware Prerequisites

Replicating this setup requires specific hardware and network configurations :
* **Robot Arm:** Franka Panda Arm & Franka Hand (with safety switches and Franka Control Unit).
* **Vision:** 2x Intel RealSense D415 or D-class cameras (one hand-mounted, one setup-mounted).
* **Calibration Objects:** Printed GRASPA layout boards and a custom 3D-printed ArUco marker cube (4cm inner squares).
* **Network:** Both workstations must be connected to the same local LAN, with the Control Workstation maintaining a direct point-to-point connection to the Franka Control Unit.

## Repository Structure & Usage

Because the framework relies on a distributed architecture to separate real-time control from heavy GPU computation, this repository is split into two main directories. 

**Please navigate to each directory and follow the instructions in their respective `README.md` files to run the benchmark:**

### 1. [`Robot control workstation/ros_panda_setup_graspa/`](./Robot%20control%20workstation/ros_panda_setup_graspa)
This directory handles the 1 KHz real-time control loop for the robot arm and the camera acquisition pipeline. 
* **Target Machine:** A workstation running Ubuntu with a **Real-Time (RT) Linux kernel**.
* **Function:** Runs the Docker container that homes the robot, manages the RealSense camera feeds, segments the point cloud, and executes the physical grasps. It also handles the automated reachability and calibration routine.

### 2. [`Compute workstation/docker/`](./Compute%20workstation/docker)
This directory handles the synthesis of grasp candidates using the selected algorithms.
* **Target Machine:** A workstation equipped with an **NVIDIA GPU** (e.g., RTX 5000) running standard Ubuntu.
* **Function:** Contains the Docker build scripts for Dex-Net, GPD, and 6DoF-GraspNet. It receives visual data from the control workstation, generates feasible grasps, and sends the execution commands back to the robot.

## Evaluation

After completing a benchmarking run across the GRASPA layouts, the results are logged automatically on the Control Workstation. A separate GRASPA evaluation Docker container can then be launched to process these logs, render a 3D visualization of the grasps, and output the final GRASPA metrics (S3, S4, and S5 indices). Instructions for this step are included in the Control Workstation's `README.md`.

## References

* Bottarel, F., Vezzani, G., Pattacini, U., & Natale, L. (2020). GRASPA 1.0: GRASPA is a Robot Arm graSping Performance benchmArk. *IEEE Robotics and Automation Letters, 5*(2), 836-843. https://doi.org/10.1109/LRA.2020.2965865
* Gualtieri, M., ten Pas, A., Saenko, K., & Platt, R. (2016). High precision grasp pose detection in dense clutter. *2016 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)*, 598–605. https://doi.org/10.1109/iros.2016.7759114
* Mahler, J., Liang, J., Niyaz, S., et al. (2017). Dex-Net 2.0: Deep Learning to Plan Robust Grasps with Synthetic Point Clouds and Analytic Grasp Metrics. *Robotics: Science and Systems XIII*. https://doi.org/10.15607/rss.2017.xiii.058
* Mousavian, A., Eppner, C., & Fox, D. (2019). 6-DOF GraspNet: Variational Grasp Generation for Object Manipulation. *2019 IEEE/CVF International Conference on Computer Vision (ICCV)*, 2901–2910. https://doi.org/10.1109/iccv.2019.00299