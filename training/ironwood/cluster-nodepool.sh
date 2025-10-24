export PROJECT_ID=diesel-patrol-382622
export ZONE=us-central1-c
 # Example: us-central1-c
export CLUSTER_NAME=rick-ironwood
export GKE_VERSION=1.34.0-gke.2201000 # or later
export ACCELERATOR_TYPE=tpu7x-32 # Example: tpu7x-128. Use tpu7x-<numCores> (chips is ½ of numCores)
export NUM_SLICES=1 # Example: 2
#export RESERVATION_NAME=<reservation_name> # Optional: Your TPU reservation name.
export BASE_OUTPUT_DIR="gs://rick-maxdiffusion"
