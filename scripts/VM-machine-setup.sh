#update system
sudo apt update
sudo apt-get update
sudo apt-get upgrade -y

# Setup Docker(for 3rd command, use your ubuntu username)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker vikashdas770
newgrp docker


# Setup Google Cloud
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-409.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-409.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh --path-update true



# Download the launch agent binary and verify the checksum
mkdir configurations
cd configurations
curl https://raw.githubusercontent.com/CircleCI-Public/runner-installation-files/main/download-launch-agent.sh > download-launch-agent.sh
export platform=linux/amd64 && sh ./download-launch-agent.sh


# Create the circleci user & working directory
id -u circleci &>/dev/null || sudo adduser --disabled-password --gecos GECOS circleci
sudo mkdir -p /var/opt/circleci
sudo chmod 0750 /var/opt/circleci
sudo chown -R circleci /var/opt/circleci /opt/circleci/circleci-launch-agent



# Create a CircleCI runner configuration
sudo mkdir -p /etc/opt/circleci
sudo nano /etc/opt/circleci/launch-agent-config.yaml


# (copy from line 41-47 and paste on VM terminal then ctrl+s, ctrl+x)
api:
    auth_token: 931bc678a60d55536744a1d83e146e03aba7a28b68c32229dca93df8f61d345c758f0738df2ccbc0

runner:
    name: self-hosted
    working_directory: /var/opt/circleci/workdir
    cleanup_working_directory: true



###########
sudo chown circleci: /etc/opt/circleci/launch-agent-config.yaml
sudo chmod 600 /etc/opt/circleci/launch-agent-config.yaml



# Enable the systemd unit
sudo nano /usr/lib/systemd/system/circleci.service

#Put Content in the circleci.service

[Unit]
Description=CircleCI Runner
After=network.target
[Service]
ExecStart=/opt/circleci/circleci-launch-agent --config /etc/opt/circleci/launch-agent-config.yaml
Restart=always
User=circleci
NotifyAccess=exec
TimeoutStopSec=18300
[Install]
WantedBy = multi-user.target


##############
sudo chown root: /usr/lib/systemd/system/circleci.service
sudo chmod 644 /usr/lib/systemd/system/circleci.service
sudo usermod -aG docker circleci
newgrp docker


# Start CircleCI
sudo systemctl enable circleci.service
sudo systemctl start circleci.service
sudo systemctl restart circleci.service
sudo systemctl status circleci.service

## Now stop and start the VM

# check docker related info
docker ps -a

# check self-hosted runner status
sudo systemctl status circleci.service
