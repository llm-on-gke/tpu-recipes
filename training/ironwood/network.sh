export PROJECT_ID=cloud-tpu-multipod-dev
export ZONE=us-central1-c
export REGION=us-central1
export RESOURCE_NAME=rickchen-gke
export NETWORK_NAME=${RESOURCE_NAME}-privatenetwork
export SUBNET_NAME=${RESOURCE_NAME}-privatesubnet
export NETWORK_FW_NAME=${RESOURCE_NAME}-privatefirewall
export ROUTER_NAME=${RESOURCE_NAME}-network
export NAT_CONFIG=${RESOURCE_NAME}-natconfig

gcloud compute networks create ${NETWORK_NAME} --mtu=8896 --project=${PROJECT_ID} --subnet-mode=custom --bgp-routing-mode=regional
gcloud compute networks subnets create "${SUBNET_NAME}" --network="${NETWORK_NAME}" --range=10.10.0.0/18 --region="${REGION}" --project=$PROJECT_ID
gcloud compute firewall-rules create ${NETWORK_FW_NAME} --network ${NETWORK_NAME} --allow tcp,icmp,udp --project=${PROJECT_ID}
gcloud compute routers create "${ROUTER_NAME}" \
  --project="${PROJECT_ID}" \
  --network="${NETWORK_NAME}" \
  --region="${REGION}"
gcloud compute routers nats create "${NAT_CONFIG}" \
  --router="${ROUTER_NAME}" \
  --region="${REGION}" \
  --auto-allocate-nat-external-ips \
  --nat-all-subnet-ip-ranges \
  --project="${PROJECT_ID}" \
  --enable-logging


export NETWORK_NAME_2=${RESOURCE_NAME}-privatenetwork-2
export SUBNET_NAME_2=${RESOURCE_NAME}-privatesubnet-2
export FIREWALL_RULE_NAME=${RESOURCE_NAME}-privatefirewall-2
export ROUTER_NAME=${RESOURCE_NAME}-network-2
export NAT_CONFIG=${RESOURCE_NAME}-natconfig-2
export REGION=us-central1

gcloud compute networks create "${NETWORK_NAME_2}" --mtu=8896 --bgp-routing-mode=regional --subnet-mode=custom --project=$PROJECT_ID
gcloud compute networks subnets create "${SUBNET_NAME_2}" --network="${NETWORK_NAME_2}" --range=10.10.0.0/18 --region="${REGION}" --project=$PROJECT_ID

gcloud compute firewall-rules create "${FIREWALL_RULE_NAME}" --network "${NETWORK_NAME_2}" --allow tcp,icmp,udp --project="${PROJECT_ID}"

gcloud compute routers create "${ROUTER_NAME}" \
  --project="${PROJECT_ID}" \
  --network="${NETWORK_NAME_2}" \
  --region="${REGION}"
gcloud compute routers nats create "${NAT_CONFIG}" \
  --router="${ROUTER_NAME}" \
  --region="${REGION}" \
  --auto-allocate-nat-external-ips \
  --nat-all-subnet-ip-ranges \
  --project="${PROJECT_ID}" \
  --enable-logging

