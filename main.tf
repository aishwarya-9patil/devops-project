resource "aws_instance" "devops_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [var.security_group]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    
    # Install Java (Required for Jenkins & SonarQube)
    sudo apt install -y openjdk-11-jdk

    # Install Jenkins
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update -y
    sudo apt install -y jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins

    # Install Maven
    sudo apt install -y maven

    # Install SonarQube
    sudo apt install -y unzip
    sudo wget -O sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.2.77730.zip
    sudo unzip sonarqube.zip -d /opt/
    sudo mv /opt/sonarqube-* /opt/sonarqube
    sudo useradd -r -M -d /opt/sonarqube -s /bin/bash sonarqube
    sudo chown -R sonarqube:sonarqube /opt/sonarqube
    sudo su - sonarqube -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"

    # Install Nexus Repository
    sudo apt install -y openjdk-8-jdk
    sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
    sudo tar -xzvf nexus.tar.gz -C /opt/
    sudo mv /opt/nexus-* /opt/nexus
    sudo useradd -r -M -d /opt/nexus -s /bin/bash nexus
    sudo chown -R nexus:nexus /opt/nexus
    sudo su - nexus -c "/opt/nexus/bin/nexus start"

    # Install ArgoCD
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

    # Install AWS CLI
    sudo apt install -y awscli

    # Install Docker
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu

    # Install Kubernetes CLI (kubectl)
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl

    # Install Terraform
    sudo apt install -y wget unzip
    wget -O terraform.zip https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip
    sudo unzip terraform.zip -d /usr/local/bin/
    rm terraform.zip

    # Install Ansible
    sudo apt install -y ansible

    # Install Helm (Kubernetes Package Manager)
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    echo "Installation complete!"
  EOF

  tags = {
    Name = "DevOps-Server"
  }
}
