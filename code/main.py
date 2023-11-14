import functions_framework
from google.cloud import pubsub_v1

@functions_framework.http

def publish_message(request):
    #get the incoming data from http request
    request_json = request.get_json
    topic_name = request_json.get("topic", "default topic name")
    message_data = request_json.get("message","default message content")

    #Create a pub/sub client
    publisher = pubsub_v1.PublisherClient()

    #Create a topic name
    topic_path = publisher.topic_path("manojproject1-396309", "pubsubmy_topic1")

    #publish message to a topic
    future = publisher.publish(topic_path, data=message_data.encode("utf-8"))
    message_id = future.result
    
    return f"Message {message_id} is published to topic {topic_name}"
