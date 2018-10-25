provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "tgoncalves_http_ssh" {
  name        = "tgoncalves_http_ssh"
  description = "Allow ssh and http inbound traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "tgoncalves_secgroup"
  }
}

resource "aws_key_pair" "tgoncalves_keypair" {
  key_name   = "tgoncalves_ssh"
  public_key = "${file(var.ssh_public_key_path)}"
}

resource "aws_instance" "tgoncalves_myapp" {
  ami           = "ami-00035f41c82244dab"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.tgoncalves_keypair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.tgoncalves_http_ssh.id}"]
  tags {
    Name = "tgoncalves"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.tgoncalves_myapp.public_ip} > ip_address.txt"
  }
  provisioner "file" {
    connection {
      user = "ubuntu"
    }
    source      = "./docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }
  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get --assume-yes install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get --assume-yes update",
      "sudo apt-get --assume-yes install docker-ce",
      "sudo docker swarm init",
      "mkdir data",
      "sudo docker stack deploy -c docker-compose.yml mylbapp"
    ]
  }
}


