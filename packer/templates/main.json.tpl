{
  "variables": {
    "project_name": "{{env `PROJECT_NAME`}}"
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "aws_region": "{{env `AWS_DEFAULT_REGION`}}",
    "aws_type": "{{env `PACKER_AWS_TYPE`}}",
    "aws_source_ami": "{{env `PACKER_AWS_AMI`}}",
    "aws_instance_type": "{{env `PACKER_AWS_INSTANCE_TYPE`}}",
    "aws_subnet_id": "{{env `PACKER_AWS_SUBNET_ID`}}",
    "aws_username": "{{env `PACKER_AWS_USERNAME`}}",
    "ansible_staging_directory": "{{env `PACKER_ANSIBLE_STAGING_DIRECTORY`}}",
    "ansible_roles_source": "{{env `PACKER_ANSIBLE_ROLES_SOURCE`}}",
    "ansible_roles_directory": "{{env `PACKER_ANSIBLE_ROLES_DIRECTORY`}}",
    "ansible_playbook": "{{env `PACKER_PLAYBOOK`}}",
    "ansible_main_role": "{{env `PACKER_MAIN_ROLE`}}",
  },
  "builders": [
    {
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}",
      "region": "{{user `aws_region`}}",
      "type": "{{user `aws_type`}}",
      "source_ami": "{{user `aws_source_ami`}}",
      "instance_type": "{{user `aws_instance_type`}}",
      "subnet_id": "{{user `aws_subnet_id`}}",
      "ssh_username": "{{user `aws_username`}}",
      "ssh_pty": true,
      "associate_public_ip_address": true,
      "ssh_timeout": "5m",
      "ami_name": "{{user `project_name`}}_{{isotime | clean_ami_name}}"
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "sudo yum install gcc python-devel python-crypto python-pip -y",
        "sudo pip install ansible",
        "mkdir -p {{user `ansible_staging_directory`}}"
      ]
    },
    {
      "type": "file",
      "source": "{{user `ansible_source`}}",
      "destination": "{{user `ansible_roles_directory`}}"
    },
    {
      "type": "ansible-local",
      "playbook_file": "{{user `ansible_playbook`}}",
      "staging_directory": "{{user `ansible_staging_directory`}}",
      "role_paths": [
        "{{user `ansible_main_role`}}"
      ]
    }
  ]
}