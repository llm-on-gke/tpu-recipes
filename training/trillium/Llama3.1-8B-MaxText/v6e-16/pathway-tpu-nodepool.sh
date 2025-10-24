CLUSTER=rick-tpu-pathway
PROJECT=diesel-patrol-382622
ZONE=us-central1-b
REGION=us-central1
CLUSTER_VERSION=1.34
PW_CPU_MACHINE_TYPE="n2-standard-64"
NETWORK=xpk-rick-test-mtu9k
SUBNETWORK=default
CLUSTER_NODEPOOL_COUNT=2
TPU_MACHINE_TYPE="ct6e-standard-4t" #"ct6e-standard-4t"
WORKERS_PER_SLICE=2 #2 for 4t
TOPOLOGY="2x4"
NUM_CPU_NODES=1
PW_CPU_MACHINE_TYPE="n2-standard-64"

gcloud beta container clusters create ${CLUSTER} \
--project=${PROJECT} \
--region=$REGION \
--cluster-version=${CLUSTER_VERSION} \
--scopes=storage-full,gke-default,cloud-platform \
--machine-type ${PW_CPU_MACHINE_TYPE} \
--network=${NETWORK} \
--subnetwork=${SUBNETWORK}

gcloud container node-pools create "cpu-pathways-np" \
--project ${PROJECT} \
--region=${REGION} \
--node-locations=${ZONE} \
--cluster ${CLUSTER} \
--machine-type ${PW_CPU_MACHINE_TYPE} \
--num-nodes ${NUM_CPU_NODES} \
--scopes=storage-full,gke-default,cloud-platform \
--workload-metadata=GCE_METADATA


#for 2x4t
for i in $(seq 1 ${CLUSTER_NODEPOOL_COUNT}); do
gcloud container node-pools create "tpu-pathway-${i}" \
--project=${PROJECT} \
--region=${REGION} \
--node-locations=${ZONE} \
--cluster=${CLUSTER} \
--machine-type=${TPU_MACHINE_TYPE} \
--num-nodes=${WORKERS_PER_SLICE} \
--placement-type=COMPACT \
--tpu-topology=${TOPOLOGY} \
--scopes=storage-full,gke-default,cloud-platform \
--workload-metadata=GCE_METADATA --spot
done

