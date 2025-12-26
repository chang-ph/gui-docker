all:
	docker build -t 649703601684.dkr.ecr.us-west-2.amazonaws.com/squashed-julia:ubvnc -f Dockerfile .
	docker push 649703601684.dkr.ecr.us-west-2.amazonaws.com/squashed-julia:ubvnc
