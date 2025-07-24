data "aws_ami" "master" {
  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  filter {
    name   = "name" # Adaptez ce filtre
    values = ["rex-devsecops-master*"]
  }
}

data "aws_ami" "worker" {
  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  filter {
    name   = "name" # Adaptez ce filtre
    values = ["rex-devsecops-worker*"]
  }
}