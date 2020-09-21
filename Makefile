OWNER=bimoyong
IMAGE_NAME=${OWNER}/opencv
IMAGE_NAME_CUDA=${OWNER}/opencv-cuda
CUDA_VER=10.1
OPENCV_VER=4.4.0
PYTHON_VER=3.6
OS=ubuntu18.04
IMAGE_TAG=${OPENCV_VER}-python${PYTHON_VER}-${OS}

docker_multiarch:
	docker buildx build \
		--file multiarch.Dockerfile \
		--push \
		--platform linux/arm,linux/arm64,linux/amd64 \
		--build-arg OPENCV_VER=${OPENCV_VER} \
		--build-arg PYTHON_VER=${PYTHON_VER} \
		--build-arg OS=${OS} \
		--tag ${IMAGE_NAME}:${IMAGE_TAG} \
		--tag ${IMAGE_NAME}:latest .

docker_cuda:
	docker build \
		--file cuda.Dockerfile \
		--build-arg OWNER=${OWNER} \
		--build-arg CUDA_VER=${CUDA_VER} \
		--build-arg OPENCV_VER=${OPENCV_VER} \
		--build-arg PYTHON_VER=${PYTHON_VER} \
		--build-arg OS=${OS} \
		--build-arg TARGETARCH=amd64 \
		--tag ${IMAGE_NAME_CUDA}:${IMAGE_TAG} .
	docker tag ${IMAGE_NAME_CUDA}:${IMAGE_TAG} ${IMAGE_NAME_CUDA}:latest
	docker push ${IMAGE_NAME_CUDA}:${IMAGE_TAG}
	docker push ${IMAGE_NAME_CUDA}:latest

docker_multiarch_cuda:
	docker buildx build \
		--file multiarch-cuda.Dockerfile \
		--push \
		--platform linux/arm,linux/arm64,linux/amd64 \
		--build-arg OWNER=${OWNER} \
		--build-arg CUDA_VER=${CUDA_VER} \
		--build-arg OPENCV_VER=${OPENCV_VER} \
		--build-arg PYTHON_VER=${PYTHON_VER} \
		--build-arg OS=${OS} \
		--tag ${IMAGE_NAME_CUDA}:${IMAGE_TAG} \
		--tag ${IMAGE_NAME_CUDA}:latest .


.PHONY: docker docker_multiarch docker_multiarch_cuda
