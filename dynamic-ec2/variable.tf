variable "ec2_config" {
  type = list(object({
    ami_key = string
    name = string
    instance_type = string
    count = optional(number, 1)
  }))
}
