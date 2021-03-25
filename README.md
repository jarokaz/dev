# JK Data Science Workbench


## Creating AI Platform Notebooks with Theai

```
export CONTAINER_URI="gcr.io/deeplearning-platform-release/experimental.theia.1-7"
export INSTANCE_NAME=...
export PROJECT_NAME=...
export IMAGE_PROJECT="deeplearning-platform-release"
export IMAGE_FAMILY="theia-container-experimental"
export MACHINE_TYPE=... #"n1-standard-4" 
export ZONE=... #"us-central1-a"
gcloud compute instances create "${INSTANCE_NAME}" \
        --project="${PROJECT_NAME}" \
        --zone="${ZONE}" \
        --image-project="${IMAGE_PROJECT}" \
        --image-family=$IMAGE_FAMILY \
        --machine-type="${MACHINE_TYPE}" \
        --boot-disk-size=200GB \
        --tags="deeplearning-vm" \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --metadata=install-nvidia-driver=True,proxy-mode=project_editors,container=${CONTAINER_URI},agent-health-check-interval-seconds=0
 ```
 
 ```
export CONTAINER_URI="gcr.io/deeplearning-platform-release/experimental.theia.1-7"
export INSTANCE_NAME=...
export PROJECT_NAME=...
export IMAGE_PROJECT="deeplearning-platform-release"
export IMAGE_FAMILY="theia-container-experimental"
export MACHINE_TYPE=... #"n1-standard-4"
export ZONE=.... #"us-central1-a"
gcloud notebooks instances create "${INSTANCE_NAME}" \
        --project="${PROJECT_NAME}" \
        --location="${ZONE}" \
        --vm-image-project="${IMAGE_PROJECT}" \
        --vm-image-family=$IMAGE_FAMILY \
        --machine-type="${MACHINE_TYPE}" \ 
        --metadata=install-nvidia-driver=True,proxy-mode=project_editors,container=${CONTAINER_URI},agent-health-check-interval-seconds=0

 ```
