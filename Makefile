# Default target will build both images.
all: winebase grlevelx

# Build the Wine base image.
winebase:
	docker build -f Dockerfile.wine -t professorcha0s/winebase:latest .

# Build the GRLevelX image.
grlevelx:
	docker build -f Dockerfile -t professorcha0s/grlevelx:latest .

# Push the images to Docker Hub.
push:
	docker push professorcha0s/winebase:latest
	docker push professorcha0s/grlevelx:latest

