output "eks_cluster_id" {
  description = "eks id"
  value       = aws_eks_cluster.cluster.id
}

output "eks_cluster_name" {
  description = "eks name"
  value       = aws_eks_cluster.cluster.name
}
