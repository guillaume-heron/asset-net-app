output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}

output "key_vault_secrets" {
  value = {
    for secret in azurerm_key_vault_secret.secrets:
    secret.name => secret.versionless_id
  }
}