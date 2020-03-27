docker image build -t docker.io/cadull/ai-attach-lab-api:latest src/api
docker image push docker.io/cadull/ai-attach-lab-api:latest
docker image build -t docker.io/cadull/ai-attach-lab-app:latest src/app
docker image push docker.io/cadull/ai-attach-lab-app:latest