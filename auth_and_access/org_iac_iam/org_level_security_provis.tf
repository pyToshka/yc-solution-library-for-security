resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
}

#Create folder in security
resource "yandex_resourcemanager_folder" "cloud_admin" {
  cloud_id = yandex_resourcemanager_cloud.create-clouds[2].id
  name = "cloud-admin"
  depends_on = [time_sleep.wait_60_seconds]
}

#Create sa
resource "yandex_iam_service_account" "sec-sa-trail" {
  name        = "sa-trails-admin"
  folder_id = yandex_resourcemanager_folder.cloud_admin.id

}

# Bind sa audit trails roles
resource "yandex_organizationmanager_organization_iam_member" "trails-bind-sa" {
  organization_id = var.ORG_ID
  role     = "audit-trails.admin"
  member   = "serviceAccount:${yandex_iam_service_account.sec-sa-trail.id}"
}
