OWNER=brazn
IMAGE_NAME=${OWNER}/opencv-cuda
CUDA_VER=10.1
OPENCV_VER=4.4.0
PYTHON_VER=3.6
OS=ubuntu18.04
IMAGE_TAG=${OPENCV_VER}-python${PYTHON_VER}-${OS}

docker_cuda:
	docker build \
		--file cuda.Dockerfile \
		--build-arg CUDA_VER=${CUDA_VER} \
		--build-arg OPENCV_VER=${OPENCV_VER} \
		--build-arg PYTHON_VER=${PYTHON_VER} \
		--build-arg OS=${OS} \
		--build-arg TARGETARCH=amd64 \
		--tag ${IMAGE_NAME}:${IMAGE_TAG} .
	docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
	docker push ${IMAGE_NAME}:${IMAGE_TAG}
	docker push ${IMAGE_NAME}:latest

docker_multiarch:
	docker buildx build \
		--file multiarch.Dockerfile \
		--push \
		--platform linux/arm,linux/arm64,linux/amd64 \
		--build-arg CUDA_VER=${CUDA_VER} \
		--build-arg OPENCV_VER=${OPENCV_VER} \
		--build-arg PYTHON_VER=${PYTHON_VER} \
		--build-arg OS=${OS} \
		--tag ${IMAGE_NAME}:${IMAGE_TAG} \
		--tag ${IMAGE_NAME}:latest .

docker_multiarch_cuda:
	docker buildx build \
		--file multiarch-cuda.Dockerfile \
		--push \
		--platform linux/arm,linux/arm64,linux/amd64 \
		--build-arg CUDA_VER=${CUDA_VER} \
		--build-arg OPENCV_VER=${OPENCV_VER} \
		--build-arg PYTHON_VER=${PYTHON_VER} \
		--build-arg OS=${OS} \
		--tag ${IMAGE_NAME}:${IMAGE_TAG} \
		--tag ${IMAGE_NAME}:latest .


.PHONY: docker docker_multiarch docker_multiarch_cuda
