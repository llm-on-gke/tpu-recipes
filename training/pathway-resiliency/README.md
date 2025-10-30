# Instructions for training Llama3.1-8B-MaxText on TPU trillium (v6e-16)

## XPK setup
Please follow the [XPK_README](https://github.com/AI-Hypercomputer/tpu-recipes/blob/main/training/trillium/XPK_README.md) to create your GKE cluster with XPK

## Prep for Maxtext

### Install Maxttext and Build Docker Image for Pathway resiliency
git clone https://github.com/AI-Hypercomputer/maxtext/
cd maxtext
git checkout lukebaumann-pause-resume

MODE=nightly #or stable
DEVICE=tpu
IMAGE_LOCATION=us-east4-docker.pkg.dev/diesel-patrol-382622/gke-llm/maxtext_resiliency_image:latest
LOCAL_IMAGE_NAME=maxtext_pathways_image
bash ./docker_build_dependency_image.sh LOCAL_IMAGE_NAME="${LOCAL_IMAGE_NAME}" MODE="$MODE" DEVICE="$DEVICE"

e.g., bash ./docker_build_dependency_image.sh LOCAL_IMAGE_NAME="maxtext_resiliency_image" MODE="stable" DEVICE="tpu"

https://source.corp.google.com/piper///depot/google3/cloud/tpu/tools/multipod/kokoro_tests/pathways_on_cloud/gcp_ubuntu_docker/maxtext.sh

Tag and push the image to atifact registry
```
docker tag maxtext_base_image us-east4-docker.pkg.dev/diesel-patrol-382622/gke-llm/maxtext_resiliency_image:latest
gcloud auth configure-docker us-east4-docker.pkg.dev
docker push us-east4-docker.pkg.dev/diesel-patrol-382622/gke-llm/maxtext_resiliency_image:latest #replace with your own image path
```

## Run Maxtext Llama3.1-8B Resiliency Demo on GKE


#### Prepare TPU VM or GKE TPU Cluster to run prerequisistes
Prerequisites:
Have a GKE cluster ready to install nodepools. 

Update config and run the following shell script
```
bash pathway-tpu-nodepool.sh
```

Validate one CPU nodepool and 2 trillium nodepools created. 
#### Download dataset



#### Download checkpoints

### Starting workload

From the MaxText root directory, start your Llama3.1-8B workload.
```
kubectl apply -f pathway-resiliency-workload.yaml
```

From your workload logs, you should start seeing step time logs like the following:
```
completed step: 14, seconds: 3.393, TFLOP/s/device: 419.485, Tokens/s/device: 7243.378, total_weights: 393216, loss: 3.974
```

### Demo Details

There are 2 slices of trillium 2x4t. 
Choose any of tpu node, 
```
node_name=XXXX
kubectl drain "$node_name" --grace-period=0 --ignore-daemonsets
echo "Node cordoned. Waiting briefly for training to reconfigure to N-1 slices..."
sleep 120s
echo "Uncordoning node '$node_name' to allow scheduling again."
kubectl uncordon "$node_name"
```

