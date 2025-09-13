##note; GKE cluser need to be 1.32.2-gke.1652000 or later to use flex-start.

gcloud container node-pools create v6e-16-spot \
    --location=us-central1 \
    --cluster=rick-tpu-standard \
    --node-locations=us-central1-b \
    --machine-type=ct6e-standard-4t \
    --tpu-topology=4x4 \
    --enable-autoscaling \
    --num-nodes 4 \
    --min-nodes=0 \
    --max-nodes=4 \
    --service-account="314837540096-compute@developer.gserviceaccount.com" \
    --spot