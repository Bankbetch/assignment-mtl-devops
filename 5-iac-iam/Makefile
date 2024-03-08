
install:
	terraform apply -var-file="./var/$(FILENAME).tfvars" -auto-approve

dryrun:
	terraform plan -var-file="./var/$(FILENAME).tfvars" -out ./dry-run/$(FILENAME).tfplan

destroy:
	terraform apply -destroy -var-file="./var/$(FILENAME).tfvars" -auto-approve

prepare:
	terraform init -upgrade