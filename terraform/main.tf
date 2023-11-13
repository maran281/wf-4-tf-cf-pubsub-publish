provider "google" {
    project = "manojproject1-396309"
    region = "us-east1"
}

/* resource "google_service_account" "my-pubsub-sa" {
    display_name = "my-pubsub-sa"
    account_id = "my-pubsub-sa@manojproject1-396309.iam.gserviceaccount.com"
}

resource "google_project_iam_binding" "service_account_roles" {
    project = "manojproject1-396309" 

    role = "roles/pubsub.publisher"
    members = [ "serviceAccount:${google_service_account.my-pubsub-sa.email}" ]

} */

resource "google_pubsub_topic" "pubsubtopic1" {
    name = "pubsubmy_topic1"
  
}

/* Below is the pull suibscription which is a default behaviour. 
for Push subscription you have to define it with the https url 
where the message should be pushed. */ 
resource "google_pubsub_subscription" "mysubscription1" {

    name = "my_subscription1"
    topic = google_pubsub_topic.pubsubtopic1.name

}
