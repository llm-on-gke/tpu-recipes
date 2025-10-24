CLUSTER_NAME=rick-chen-tpu7x
PROJECT_ID=cloud-tpu-multipod-dev
GKE_VERSION=1.34.0-gke.2201000 # or later is supported
DISK_TYPE=hyperdisk-balanced # hyperdisk-extreme, hyperdisk-ml, or hyperdisk-throughput
MACHINE_TYPE=n1-standard-8 # CPU machine type for system pods to land on
ZONE=us-central1-c

gcloud container clusters create ${CLUSTER_NAME} --cluster-version=${GKE_VERSION} --network=briankang-gke-cputest-privatenetwork  --machine-type=${MACHINE_TYPE} --zone=us-central1-c --project=${PROJECT_ID} --disk-type=${DISK_TYPE} --enable-dataplane-v2 --enable-ip-alias --enable-multi-networking \
--workload-pool=${PROJECT_ID}.svc.id.goog \
--addons GcsFuseCsiDriver

WORKLOAD_POLICY_NAME=tpu7x-workload-policy # user-assigned text
TOPOLOGY=2x2x4 # Refer to topology segment to see all supported Ironwood topologies 

gcloud compute resource-policies create workload-policy ${WORKLOAD_POLICY_NAME} \
--type HIGH_THROUGHPUT \
--accelerator-topology ${TOPOLOGY} \
--project ${PROJECT_ID} \
--region us-central1


NODE_POOL_NAME=tpu7x-2-2-4
gcloud container node-pools create ${NODE_POOL_NAME} \
  --cluster=${CLUSTER_NAME} \
  --machine-type=tpu7x-standard-4t \
  --placement-policy=${WORKLOAD_POLICY_NAME} \
  --additional-node-network=network=rickchen-gke-privatenetwork-2,subnetwork=rickchen-gke-privatesubnet-2 \
  --num-nodes=4 --reservation=cloudtpu-20251017124413-573252602 --reservation-affinity=specific \
  --zone=${ZONE} --project=${PROJECT_ID}


