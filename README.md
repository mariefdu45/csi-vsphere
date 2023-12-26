# csi-vsphere
This repository is for installing VSphere cpi and csi on a vanilla K8S cluster located on vsphere in an Infrastructure as code way (IaC)

> Ce dépot a pour but d'installer VSphere CPI et CSI en Infrastructure as code way (IaC) sur un cluster Kubernetes Vanilla hébergé sur une infrastructure VMWare.


## Some theory about CSI
> Un peu de théorie à propos de CSI

In the first Kubernetes releases, storage drivers were included in Kubernetes code (in-tree), regarding VMware, it was VCP (vSphere Cloud Provide). For convenience and agility, drivers were outsourced from the kubernetes kernel in CSI (Container Storage Interface) which are out-of-tree drivers. For Vmmare, it is csi-vsphere.
As the CSI driver is for managing persistent volumes (create, attach, detach, delete, mount, unmount) and if it is included like in VSphere for managing snapshots,an other component was needed in Kubernetes for managing specific cloud caracteristic like  zones, regions or nodes types and size, this second interface is CPI (Cloud Provider Interface).
> Dans les premières versions de Kubernetes, les pilotes de stockages étaient intégrés dans le code de Kubernetes (in-tree), VCP (vSphere Cloud Provide) était le pilote fournit par VMWare. Pour des raisons pratiques, les pilotes ont été ensuite sortis de Kubernetes pour être installés de manière optionnelle en tant que CSI (Container Storage Interface) qui contrairement aux premiers sont des pilotes out-of-tree.


On another side, VMware with VSphere 6.7 annouced CNS (VMware Cloud Native Storage). CNS purpose is included in VSphere and provided for managing what VSphere CSI-vsphere in Kubernetes transmit to it. It can create persistent volumes without any virtual machine dependency as vmdk files (FCD First Class Disks) or vSphere 7 File Shares especially for Read Write Many persistent volumes.
> Parallemement à cela, VMware a intégré à partir de la version 6.7 de Vsphere le CNS (VMware Cloud Native Storage). Celui-ci a pour rôle de créer des fichiers .vmdk pour répondre au besoin de création de persistent volumes ou .vmsn pour les snapshots sans nécessité de machines virtuelles associées. A partir de la version 7 de VSphere des partages NFS sur VSAN peuvent également répondre au besoin de création de persistent volumes de type Read Write Many.

<img src="https://github.com/mariefdu45/csi-vsphere/assets/96368239/cd1af133-08fd-4b21-affa-a512dd9c1f2a"  width="350"/>
<img align="right" src="https://github.com/mariefdu45/csi-vsphere/assets/96368239/1e5fdd77-e92a-4cb3-bc48-8a09d2588a8a"  width="600"/>


## Installating on your cluster
### Prerequisite
- A running kubernetes cluster with nodes as virtual machines on VSphere.
- Linux workstation with kubectl, git and govc for managing VSphere

### Installation
```bash
# Get repository
git clone https://github.com/mariefdu45/csi-vsphere.git
cd csi-vsphere
```
- Customizing govc.env if needed, this is for govc to access vcenter.
- Customizing variables.env, this is for the repository puropose.
  
```bash
# Variables initialisation
source ./govc.env  # if needed
source ./variables.env
# using installation script
./configuration/main.sh install
```

### CPI testing
```bash
kubectl get pods -n kube-system | grep vsphere-cloud-controller-manager
```
vsphere-cloud-controller-manager-vggvs   1/1     Running   0             39s
```bash
kubectl get pods -n kube-system | grep vsphere-cloud-controller-manager | awk '{print $1}' | xargs kubectl logs -n kube-system | grep "Successfully initialized node"
```
![image](https://github.com/mariefdu45/csi-vsphere/assets/96368239/16bca8af-cda2-48c5-98cd-cf049d3425ae)


### CSI testing
```bash
kubectl get secret,all -n vmware-system-csi
```
![image](https://github.com/mariefdu45/csi-vsphere/assets/96368239/f2351a4c-dda8-4bc2-963a-36001dcc37cf)


```bash
kubectl get csidrivers
```
![image](https://github.com/mariefdu45/csi-vsphere/assets/96368239/bea2e6a9-fcb8-43a8-8dcf-2c620052f457)

```bash
kubectl get csinodes
```
![image](https://github.com/mariefdu45/csi-vsphere/assets/96368239/19cdc5ce-861d-42e5-af58-6ce4dbe50866)

```bash
kubectl get storageclasses
```
![image](https://github.com/mariefdu45/csi-vsphere/assets/96368239/ec074ea5-8ff1-4e4c-9ee3-838b35fba13d)

### Removing

```bash
./configuration/main.sh uninstall

```
