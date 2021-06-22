#----------------------------------------------------------------------------
# REQUIRED PARAMETERS: You must provide a value for each of these parameters.
#----------------------------------------------------------------------------

variable "key_name" {
  description = "The name of the key pair that allows to securely connect to the instance after launch"
  type        = string
  default     = "derasys-nv-key"
}

#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment i.e. dev, test, stage, prod"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "The ID of the AWS EC2 AMI to use (if null the latest Amazon Linux 2 AMI is selected)"
  type        = string
  default     = null
}

variable "app_instance_type" {
  description = "The EC2 instance type for the APP server(s)"
  type        = string
  default     = "t3.small"
}

variable "db_instance_type" {
  description = "The EC2 instance type for the DB server(s)"
  type        = string
  default     = "t3.small"
}
