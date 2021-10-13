#!/bin/bash

CANDIDATE_NAME='interview'
GETKUBECREDENTIALS='gcloud container clusters get-credentials interview-cluster --zone northamerica-northeast1-a --project techops-interview'

#============================
# create user
#============================
sudo adduser --disabled-password --gecos "" ${CANDIDATE_NAME}

#============================
# configure ssh
#============================
sudo sed -i "s/#ListenAddress/ListenAddress/" /etc/ssh/sshd_config
sudo sed -i "s/#Port/Port/" /etc/ssh/sshd_config
sudo sed -i "s/#PubkeyAuthentication/PubkeyAuthentication/" /etc/ssh/sshd_config

#============================
# get kubectl
#============================
which kubectl
if [ $? -ne 0 ]; then
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

which k9s
if [ $? -ne 0 ]; then
  wget https://github.com/derailed/k9s/releases/download/v0.24.13/k9s_Linux_x86_64.tar.gz
  tar -xvf k9s_Linux_x86_64.tar.gz
  sudo mv k9s /usr/bin
  sudo chown root:root /usr/bin/k9s
  sudo chmod +x /usr/bin/k9s
fi

#============================
# get python 
#============================
which python3.8
if [ $? -ne 0 ]; then
  sudo apt update
  sudo apt install -y wget curl build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
  sudo wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz
  sudo tar xzf Python-3.8.2.tgz
  cd Python-3.8.2
  ./configure --enable-optimizations
  sudo make altinstall
fi

#============================
# get gcloud
#============================
sleep 1

which gcloud
if [ $? -ne 0 ]; then
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-338.0.0-linux-x86_64.tar.gz
  tar -xvf ./google-cloud-sdk-338.0.0-linux-x86_64.tar.gz
  ./google-cloud-sdk/install.sh --quiet
fi

#============================
# record terminal sessions
#============================
mkdir -p /var/log/session
chmod 777 /var/log/session

cat <<\EOF > /etc/profile.d/Z90-sr.sh
#!/bin/bash
if [ "x$sr" = "x" ]; then
  timestamp=`date "+%m%d%Y%H%M"`
  output=/var/log/session/session.$USER.$$.$timestamp
  sr=s
  export sr
  script -t -f -q 2>${output}.timing $output
  exit
fi
EOF
chmod u+x /etc/profile.d/Z90-sr.sh

#============================
# connect to kubernetes cluster on user account
#============================

su ${CANDIDATE_NAME} -c "$GETKUBECREDENTIALS"; while [ $? -ne 0 ]; do su ${CANDIDATE_NAME} -c "$GETKUBECREDENTIALS"; done

