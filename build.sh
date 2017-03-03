set -ex

# docker hub username
USERNAME=sungardas
# image name
IMAGE=logcabin-docker

docker build -t $USERNAME/$IMAGE:latest .

