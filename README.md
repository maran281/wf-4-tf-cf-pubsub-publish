# wf-4-tf-cf-pubsub-publish
Github action pipeline which uses terraform to deploy:
- cloud storage bucket to store cloud function code
- cloud function which triggers and receives data from the https request in json format and publishes the data to pubsub topic
- pubsub topic where the cloud function publishes the data.
