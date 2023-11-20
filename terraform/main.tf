provider "google" {
    project = "plated-hash-405319"
    region = "us-east1"
}

/* resource "google_service_account" "my-pubsub-sa" {
    display_name = "my-pubsub-sa"
    account_id = "my-pubsub-sa@plated-hash-405319.iam.gserviceaccount.com"
}

resource "google_project_iam_binding" "service_account_roles" {
    project = "plated-hash-405319" 

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
  terraform {
    backend "gcs" {
      bucket = "terraform_state4_pubsub_poc1"   
      prefix = "terraform_state4_pubsub_poc1"
    }
  }
   
  #This bucket will contain the file, which will be picked by cloud function
  #resource "google_storage_bucket" "source_bucket_4_cf1" {
  #  name = "trigger_file_bucket1"
  #  location = "us-east1"
  #}
  
  /* #This bucket will be delete, we are using it for testing purpose
  resource "google_storage_bucket" "source_bucket_4_cf2" {
    name = "trigger_file_bucket10"
    location = "us-east1"
    #force_destroy = true
  } */
  
  #This bucket will contain the code file which will be used as cloud function code
  resource "google_storage_bucket" "tf_storage_bucket" {
    name = "cfpubsub_poc_code_bucket1"
    location = "us-east1"
  }
  
  resource "google_storage_bucket_object" "tf_bucket_object" {
    name = "main.zip"
    bucket = google_storage_bucket.tf_storage_bucket.name
    source = "../code/main.zip"
  }
  
  resource "google_cloudfunctions_function" "tf_cloud_funct" {
      name = "my_funct_4_cf_pubsub_poc"
      runtime = "python310"
      source_archive_bucket = google_storage_bucket.tf_storage_bucket.name
      source_archive_object = google_storage_bucket_object.tf_bucket_object.name
      
      trigger_http = true
      timeout = 60
      entry_point = "publish_message"
  
      /* depends_on = [ google_storage_bucket_object.tf_bucket_object ] */
  }
  
  resource "google_cloudfunctions_function_iam_member" "invoker" {
    cloud_function = google_cloudfunctions_function.tf_cloud_funct.name
    role = "roles/cloudfunctions.invoker"
    member = "allUsers"
  }
  
  #comment
