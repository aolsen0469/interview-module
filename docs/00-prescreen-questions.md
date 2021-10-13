# Prescreen Questions
-   We aren't trying to determine fit right away with these questions. We are attempting to filter out individuals who dont have enough experience
-   HR needs to be able to say effectively filter with our questions. they dont need to understand, but they do need to be black and white. There can't be any room for interpretation.  
-   We still want trivia. we just want 'relevant' trivia -- that is related to the job.
 
----------

## General
  

**Q: Ask if they have hands on experience with the technology they’ve listed**
  

**Q: Have you ever worked as a primary on-call for a production environment?**


**Q: Ensure the candidate has a pair of headphones/earbuds. Ensure they have a Webcam. Make sure their audio quality is decent, and that there is minimal latency/delay).**
  

##  Linux Knowledge

**Q: Why is it better to use a disk UUID in fstab, rather than, e.g. "/dev/sda1"?**

**A:** The device names under /dev are assigned by the kernel based on the order they are detected at boot time.
(*This can change on reboot.*)

  
  

**Q: What is the difference between these two commands?**

**A:** 

- myvar=hello and export myvar=hello
-   myvar is a local variable
-   export is a environment variable
    

  
  

**Q: Explain the three load averages and what do they indicate. What command can be used to view the load averages?**

**A:** 

-   Candidate should be able to identify that load average is a good indication of how busy a server is.  
-   A load average of less than 1 per cpu core is alright and as it becomes closer to equal to the number of cpu cores it indicates the server has more processes waiting than resources available.
-   They should also identify that load average can be influenced by other factors than just CPU (I.E. iowait).
    

  

**Q: What does iowait mean when your looking at your system stats and why does it matter?**  

**A:** Iowait is the time a process is waiting and unable to perform any actions due to a IO block, usually caused by resource contention or because the resource is too slow.

This is one of the biggest reason why load averages spike (so they might have touched upon this in the first question)

  

**Q: Explain what /proc is**

**A:** /proc is very special in that it is also a virtual filesystem. It's sometimes referred to as a process information pseudo-file system. It doesn't contain 'real' files but runtime system information (e.g. system memory, devices mounted, hardware configuration, etc).

  
  

## Kubernetes

  

**Q: What is Kubectl?**

**A:** Kubectl is a command line tool for controlling kubernetes clusters.

  

**Q: What are pods in kubernetes?**

**A:** A Kubernetes pod is a group of containers that are being deployed in the same host. Pods have the capacity to operate one level higher than the individual containers. This is because pods have the group of containers that work together to produce an artefact or to process a set of work

  
  
**Q: What are the components of kubernetes**

**A:** 

- **Okay:** Master/Workers
- **Good:** etcd, kube-apiserver, kube-controller-manager, cloud-controller-master, kube-scheduler, kubelet, kube-proxy, kubectl
- **Excellent:** what does **{X}** do?



***etcd:*** distributed key value storage which contains cluster data

***kube-apiserver:*** exposes API, communicates with etcd.

***kube-controller-manager:*** runs various controller processes which regulate the state of the cluster

***cloud-controller-manager:*** responsible for external dependencies in cloud infra

***kube-scheduler:*** schedules pods based on resource utilization.

***kubelet:*** reports to master on health of the host, ensure pods are healthy and running in desired state

***kube-proxy:*** runs on each worker node and deals with individual host subnetting and exposed services.

***kubectl;*** commandline tool which interacts with kube-api server and sends commands to master node. each command is converted into an api call.

  
  

## Containers

  

***Q: Suppose you have 3 containers running and out of these, you wish to access one of them. How do you access a running container?***

**A:** The following command lets us access a running container: 

    docker exec -it bash

*(The exec command lets you get inside a container and work with it.)*

  
  

## Configuration Management

  

***Q: You need to upgrade the kernel on 100-1000 servers, how you would do this?***

**A:** Chef, Puppet, Ansible, Salt, or some other configuration management tool.

  

***Q: What file extension does terraform look for?"***

**A:** the correct answer is “.tf”

  
  

## Networking

**Q: What is the difference between a CNAME and an A-record in DNS?**

**A:** 

  - The A record maps to one or more IP addresses.
  - the CNAME record maps to another name instead of an ip. ( This could be another CNAME or A record).

  

## Databases

  

**Q: Are you familiar with any open source relational database?**

**A:** MySql, PostgreSql are the one we are looking for

  

**Q: Have you deployed or maintained any relation database in production?**

**A:**  Yes is what we are looking for
