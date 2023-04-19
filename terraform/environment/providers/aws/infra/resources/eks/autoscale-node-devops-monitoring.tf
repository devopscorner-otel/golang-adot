# ==========================================================================
#  Resources: EKS / autoscale-node-devops.tf (EKS Autoscale Configuration)
# --------------------------------------------------------------------------
#  Description
# --------------------------------------------------------------------------
#    - Node VPC Subnet
#    - Node Scaling
#    - Node Tagging
# ==========================================================================

#============================================
# NODE GROUP - DEVOPSCORNER MONITORING & TOOLS
#============================================
locals {
  #for tagging
  Environment_devops      = "PROD"
  Name_monitoring         = "EKS-1.23-DEVOPSCORNER-MONITORING"
  Type_devops             = "PRODUCTS"
  ProductName_monitoring  = "EKS-DEVOPSCORNER"
  ProductGroup_monitoring = "MONITORING-EKS-DEVOPSCORNER"
  Department_devops       = "DEVOPS"
  DepartmentGroup_devops  = "PROD-DEVOPS"
  ResourceGroup_devops    = "PROD-EKS-DEVOPSCORNER"
  Services_monitoring     = "MONITORING"
}

# --------------------------------------------------------------------------
#  Autoscaling Schedule Node
# --------------------------------------------------------------------------
# References:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment

## Scale Down
resource "aws_autoscaling_schedule" "scale_down_devops_monitoring" {
  autoscaling_group_name = aws_eks_node_group.devops["monitoring"].resources[0].autoscaling_groups[0].name
  desired_capacity       = 0
  max_size               = 0
  min_size               = 0
  recurrence             = "0 13,16 * * *"
  scheduled_action_name  = "scale_down"
  # start_time           = "2022-03-25T13:00:00Z"
}

## Scale Up
resource "aws_autoscaling_schedule" "scale_up_devops_monitoring" {
  autoscaling_group_name = aws_eks_node_group.devops["monitoring"].resources[0].autoscaling_groups[0].name
  desired_capacity       = 3
  max_size               = 5
  min_size               = 1
  recurrence             = "0 0 * * MON-FRI"
  scheduled_action_name  = "scale_up"
  # start_time           = "2022-03-28T00:00:00Z"
}

# --------------------------------------------------------------------------
#  Autoscaling Tag
# --------------------------------------------------------------------------
# Monitoring
resource "aws_autoscaling_group_tag" "Environment_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "Environment"
    value               = local.Environment_devops
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Name_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "Name"
    value               = local.Name_monitoring
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Type_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "Type"
    value               = local.Type_devops
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "ProductName_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "ProductName"
    value               = local.ProductName_monitoring
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "ProductGroup_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "ProductGroup"
    value               = local.ProductGroup_monitoring
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Department_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "Department"
    value               = local.Department_devops
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "DepartmentGroup_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "DepartmentGroup"
    value               = local.DepartmentGroup_devops
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "ResourceGroup_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "ResourceGroup"
    value               = local.ResourceGroup_devops
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Services_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "Service"
    value               = local.Services_monitoring
    propagate_at_launch = true
  }
}

// Mandatory TAGS for Cluster-Autoscaller
resource "aws_autoscaling_group_tag" "Clustername_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "ClusterName"
    value               = "${var.eks_cluster_name}-${var.env[local.env]}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Autoscaler_ownership_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}-${var.env[local.env]}"
    value               = "owned"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Autoscaler_enable_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "Terraform_group_tag_devops_monitoring" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.devops["monitoring"].resources : resources.autoscaling_groups]
    ) : asg.name]
  )
  autoscaling_group_name = each.value
  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}

# --------------------------------------------------------------------------
#  Autoscaling Output
# --------------------------------------------------------------------------
## Scale Down ##
output "eks_node_scale_down_devops_monitoring" {
  value = aws_autoscaling_schedule.scale_down_devops_monitoring.arn
}

## Scale Up ##
output "eks_node_scale_up_devops_monitoring" {
  value = aws_autoscaling_schedule.scale_up_devops_monitoring.arn
}

# --------------------------------------------------------------------------
#  Autoscaling Node Group Output
# --------------------------------------------------------------------------
## Monitoring Output #
output "eks_node_asg_group_devops_monitoring" {
  value = aws_eks_node_group.devops["monitoring"].resources[0].autoscaling_groups[0].name
}
