
# ---------------------------------------------------------------------------------------------------------------------
# GCE VARIABLES 
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  description = "region"
  type        = string
  default     = "northamerica-northeast1-a"
}

variable "project_id" {
  description = "The name of the GCP Project where all resources will be launched."
  type        = string
  default     = "techops-interview"
}

variable "svc_account" {
  description = "service account"
  type        = string
  default     = "terraform-svc-acct"
}

variable "ssh_keys" {
  description = "SSH key metadata for bastion host"
  type        = string
  default     = "interview:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzRpa2bL7ny5GGGw15SB+ta5lcoIZFTe+9wDTed2el0oKdJ8G4T/R29YHIik2gqH5cYlxSnnaMUFSwXau4FDH4m2WqSknGDXntC4nBMIs8HDBJPXXMT1WTlKLDkgYdYI7KKGiz0kd6AUAYwd83mYKyU5D01el5HgOyXAax8fIZQE1sl8UB3HEUbz4R0uOxpd7nJpcO0D52rcWufjDCQbLmn5xkIk36B/fqUzSty/HapxSFf3NQ7PCdvUT2d+CbqcukMHSGI0U+hvPHXyezdIURSXgWuVcUu0/NRfb1HWY2xRXwsBITSfFruAKzEO5cp5e5DBm47bELovRsl5y6o0flOfbmqUK5Z2AEJb5y+tNvD3vfguLHe4FLIj9GMGBWMAcqABhqxNj0NLo5gklX3UhN1IgcIzngkuXPHniaHLRzJ+wcWNBb5MbxuZGqlelVu5Q5E8RwRtwzU2xJNbsP8U0+CAgh6QrUP5wB5re7btkCXSSk0bcsCmX3fH4w929ElTE= interview@interview-vm"
}

variable "ssh_keys2" {
  type = string
  default = <<EOT
interview:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzRpa2bL7ny5GGGw15SB+ta5lcoIZFTe+9wDTed2el0oKdJ8G4T/R29YHIik2gqH5cYlxSnnaMUFSwXau4FDH4m2WqSknGDXntC4nBMIs8HDBJPXXMT1WTlKLDkgYdYI7KKGiz0kd6AUAYwd83mYKyU5D01el5HgOyXAax8fIZQE1sl8UB3HEUbz4R0uOxpd7nJpcO0D52rcWufjDCQbLmn5xkIk36B/fqUzSty/HapxSFf3NQ7PCdvUT2d+CbqcukMHSGI0U+hvPHXyezdIURSXgWuVcUu0/NRfb1HWY2xRXwsBITSfFruAKzEO5cp5e5DBm47bELovRsl5y6o0flOfbmqUK5Z2AEJb5y+tNvD3vfguLHe4FLIj9GMGBWMAcqABhqxNj0NLo5gklX3UhN1IgcIzngkuXPHniaHLRzJ+wcWNBb5MbxuZGqlelVu5Q5E8RwRtwzU2xJNbsP8U0+CAgh6QrUP5wB5re7btkCXSSk0bcsCmX3fH4w929ElTE= interview@interview-vm
EOT
}


variable "source-troubleshooting-module" {
  description = "This is the source file or folder. It can be specified as relative to the current working directory or as an absolute path. "
  type        = string
  default     = "../live-troubleshooting-modules/k8s-rails-todo-list"
}

variable "destination-troubleshooting-module" {
  description = "This is the destination path. It must be specified as an absolute path."
  type        = string
  default     = "/home/interview/"
}



# ---------------------------------------------------------------------------------------------------------------------
# GKE VARIABLES 
# ---------------------------------------------------------------------------------------------------------------------

variable "clustername" {
  description = "service account"
  type        = string
  default     = "interview-cluster"
}

variable "auth-office-cidr" {
  type        = string
  default     = ""
}
variable "auth-vpn-cidr" {
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDDNS VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "dns_project_id" {
  type        = string
  default     = ""
}
