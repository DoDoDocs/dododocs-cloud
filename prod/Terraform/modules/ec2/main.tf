module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  for_each = { for idx, name in var.ec2_name : idx => {
    name          = name
    instance_type = var.instance_type[idx]
    private_ip    = var.private_ip[idx]
    sg_id         = var.sg_ids[idx]
    tag_value     = var.ec2_tags[idx]
    ami           = var.ami[idx]
  } }

  name                   = each.value.name
  instance_type          = each.value.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  ami                    = each.value.ami
  private_ip             = each.value.private_ip
  vpc_security_group_ids = [each.value.sg_id]

  tags = {
    Name         = "prod-${each.value.name}"
    Role         = var.iam_role
    testnet_type = each.value.tag_value
  }
}
