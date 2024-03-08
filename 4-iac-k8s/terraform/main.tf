resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  version  = var.eks_version

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = flatten([for _, v in values(aws_subnet.public_subnet) : v.id])
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "coredns"
  addon_version               = "v1.10.1-eksbuild.7"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.16.0-eksbuild.1"
}

resource "aws_eks_addon" "ebs" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.27.0-eksbuild.1"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.28.4-eksbuild.4"
}

resource "aws_eks_addon" "efs" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = "v1.7.0-eksbuild.1"
}