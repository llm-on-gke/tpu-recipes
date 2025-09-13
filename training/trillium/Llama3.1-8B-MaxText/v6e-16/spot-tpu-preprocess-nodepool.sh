##note; GKE cluser need to be 1.32.2-gke.1652000 or later to use flex-start.

gcloud container node-pools create v6e-4-spot \
    --location=us-central1 \
    --cluster=rick-tpu-standard \
    --node-locations=us-central1-b \
    --machine-type=ct6e-standard-4t \
    --enable-autoscaling \
    --num-nodes 1 \
    --min-nodes=0 \
    --max-nodes=1 \
    --service-account="314837540096-compute@developer.gserviceaccount.com" \
    --spot