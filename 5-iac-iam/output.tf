locals {
  has_encrypted_secret = length(compact(aws_iam_access_key.user_access_key_with_pgp_key[*].encrypted_secret)) > 0
}

output "username" {
  value = try(aws_iam_user.user.name, "")
}

output "iam_access_key_id" {
  value       = try(aws_iam_access_key.user_access_key[0].id, aws_iam_access_key.user_access_key_with_pgp_key[0].id, "")
}

output "iam_access_key_secret" {
  value       = try(nonsensitive(aws_iam_access_key.user_access_key[0].secret), "")
}

output "iam_access_key_encrypted_secret" {
  description = "Encrypted secret, base64 encoded"
  value       = try(aws_iam_access_key.user_access_key_with_pgp_key[0].encrypted_secret, "")
}

output "keybase_secret_key_decrypt_command" {
  description = "Decrypt access secret"
  value       = !local.has_encrypted_secret ? null : <<EOF
echo "${try(aws_iam_access_key.user_access_key_with_pgp_key[0].encrypted_secret, "")}" | base64 --decode | keybase pgp decrypt
EOF
}
