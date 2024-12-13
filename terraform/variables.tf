variable "instance_type" {
  description = "instance EC2 type"
  default     = "t3.medium"
}

variable "key_pair_name" {
  description = "key for SSH"
  type        = string
  default     = "devops-key"
}