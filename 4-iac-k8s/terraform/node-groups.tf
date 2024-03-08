resource "aws_eks_node_group" "demo_staging_spot" {
  for_each = var.instance_types

  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = each.key
  subnet_ids      = flatten([for _, v in values(aws_subnet.private_subnet) : v.id])
  instance_types  = each.value.type

  scaling_config {
    min_size     = each.value.min_size
    max_size     = each.value.max_size
    desired_size = each.value.desired_capacity
  }

  capacity_type = "SPOT"

  node_role_arn = aws_iam_role.eks_worker_role.arn
}
